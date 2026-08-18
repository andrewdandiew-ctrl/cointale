import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/mock_data.dart';
import '../../theme/app_colors.dart';
import '../../widgets/shared_widgets.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({
    super.key,
    required this.onViewStory,
    required this.onVerify,
  });

  static const routeName = '/scan';

  final void Function(BuildContext context) onViewStory;
  final void Function(BuildContext context) onVerify;

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  bool _isIdentifying = false;
  final _pageController = PageController();
  final _measurementsFormKey = GlobalKey<FormState>();
  final _weightController = TextEditingController();
  final _diameterController = TextEditingController();

  XFile? _frontImage;
  XFile? _backImage;
  XFile? _edgeImage;
  var _step = 0;
  var _showResult = false;

  @override
  void dispose() {
    _pageController.dispose();
    _weightController.dispose();
    _diameterController.dispose();
    super.dispose();
  }

  Future<void> _capturePhoto(ImageSource source) async {
    final image = await ImagePicker().pickImage(source: source);
    if (image == null || !mounted) return;

    setState(() {
      if (_step == 0) {
        _frontImage = image;
      } else if (_step == 1) {
        _backImage = image;
      } else if (_step == 2) {
        _edgeImage = image;
      }
    });
  }

  XFile? get _currentImage => switch (_step) {
    0 => _frontImage,
    1 => _backImage,
    2 => _edgeImage,
    _ => null,
  };

  Future<void> _next() async {
    if (_step < 3 && _currentImage == null) return;
    if (_step == 3) {
      if (!_measurementsFormKey.currentState!.validate()) return;
      setState(() => _isIdentifying = true);
      try {
        await _saveCoinScan();
        if (mounted) {
          setState(() {
            _isIdentifying = false;
            _showResult = true;
          });
        }
      } on FirebaseException catch (error) {
        if (mounted) {
          setState(() => _isIdentifying = false);
          _showError(_saveErrorMessage(error));
        }
      } catch (_) {
        if (mounted) {
          setState(() => _isIdentifying = false);
          _showError('We could not save this coin scan. Please try again.');
        }
      }
      return;
    }
    await _pageController.nextPage(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  Future<void> _saveCoinScan() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw StateError('A signed-in user is required.');
    }

    final scanRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('coinScans')
        .doc();

    final photos = <String, XFile>{
      'front': _frontImage!,
      'back': _backImage!,
      'edge': _edgeImage!,
    };
    final storagePaths = <String, String>{};
    final photoUrls = <String, String>{};

    for (final entry in photos.entries) {
      final photoRef = FirebaseStorage.instance.ref(
        'users/${user.uid}/coinScans/${scanRef.id}/${entry.key}.jpg',
      );
      await photoRef.putData(
        await entry.value.readAsBytes(),
        SettableMetadata(contentType: entry.value.mimeType ?? 'image/jpeg'),
      );
      storagePaths[entry.key] = photoRef.fullPath;
      photoUrls[entry.key] = await photoRef.getDownloadURL();
    }

    await scanRef.set({
      'weightGrams': double.parse(_weightController.text.trim()),
      'diameterMm': double.parse(_diameterController.text.trim()),
      'photoCaptureCompleted': true,
      'photoStoragePaths': storagePaths,
      'photoUrls': photoUrls,
      'status': 'pendingAnalysis',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  void _showError(String message) => ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: Text(message)));

  String _saveErrorMessage(FirebaseException error) {
    if (error.code == 'permission-denied') {
      return 'Saving was denied. Check your Firebase security rules.';
    }
    return 'We could not save this coin scan. Please check your connection and try again.';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E14),
      body: _showResult ? _buildResult() : _buildCaptureFlow(),
    );
  }

  Widget _buildCaptureFlow() => Stack(
    fit: StackFit.expand,
    children: [
      _CameraBackground(),
      SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  CircleIconButton(
                    icon: Icons.close,
                    onPressed: () => Navigator.of(context).pop(),
                    backgroundColor: Colors.black45,
                    iconColor: Colors.white,
                  ),
                  const Spacer(),
                  Text(
                    'Coin verification · ${_step + 1} of 4',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  const SizedBox(width: 40),
                ],
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (value) => setState(() => _step = value),
                children: [
                  _PhotoStep(
                    title: 'Photograph the front',
                    instruction:
                        'Place the coin flat and keep the full front face in frame.',
                    image: _frontImage,
                    onCamera: () => _capturePhoto(ImageSource.camera),
                    onGallery: () => _capturePhoto(ImageSource.gallery),
                  ),
                  _PhotoStep(
                    title: 'Photograph the back',
                    instruction:
                        'Turn the coin over and take a sharp, well-lit photo.',
                    image: _backImage,
                    onCamera: () => _capturePhoto(ImageSource.camera),
                    onGallery: () => _capturePhoto(ImageSource.gallery),
                  ),
                  _PhotoStep(
                    title: 'Photograph the edge / reed',
                    instruction:
                        'Stand the coin on its side so the edge detail is visible.',
                    image: _edgeImage,
                    onCamera: () => _capturePhoto(ImageSource.camera),
                    onGallery: () => _capturePhoto(ImageSource.gallery),
                  ),
                  _MeasurementsStep(
                    formKey: _measurementsFormKey,
                    weightController: _weightController,
                    diameterController: _diameterController,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _isIdentifying ? null : _next,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: _isIdentifying
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(_step == 3 ? 'Analyze coin' : 'Next'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );

  Widget _buildResult() => SafeArea(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: CircleIconButton(
              icon: Icons.close,
              onPressed: () => Navigator.of(context).pop(),
              backgroundColor: Colors.white24,
              iconColor: Colors.white,
            ),
          ),
          const Spacer(),
          _ResultCard(
            onViewStory: () => widget.onViewStory(context),
            onVerify: () => widget.onVerify(context),
            imagePath: _frontImage?.path,
          ),
          const Spacer(),
        ],
      ),
    ),
  );
}

class _PhotoStep extends StatelessWidget {
  const _PhotoStep({
    required this.title,
    required this.instruction,
    required this.image,
    required this.onCamera,
    required this.onGallery,
  });
  final String title;
  final String instruction;
  final XFile? image;
  final VoidCallback onCamera;
  final VoidCallback onGallery;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(24),
    child: Column(
      children: [
        const Spacer(),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          instruction,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white.withValues(alpha: .75),
            fontSize: 16,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 28),
        Container(
          width: 240,
          height: 240,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.gold, width: 2),
            color: Colors.white.withValues(alpha: .08),
          ),
          child: image == null
              ? const Icon(
                  Icons.camera_alt_outlined,
                  size: 64,
                  color: AppColors.gold,
                )
              : Image.file(File(image!.path), fit: BoxFit.cover),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onGallery,
                icon: const Icon(Icons.photo_library_outlined),
                label: const Text('Choose photo'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton.icon(
                onPressed: onCamera,
                icon: const Icon(Icons.camera_alt),
                label: const Text('Take photo'),
              ),
            ),
          ],
        ),
        const Spacer(),
      ],
    ),
  );
}

class _MeasurementsStep extends StatelessWidget {
  const _MeasurementsStep({
    required this.formKey,
    required this.weightController,
    required this.diameterController,
  });
  final GlobalKey<FormState> formKey;
  final TextEditingController weightController;
  final TextEditingController diameterController;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(24),
    child: Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Spacer(),
          const Text(
            'Add measurements',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Use a scale and calipers for the most accurate authenticity check.',
            style: TextStyle(
              color: Colors.white.withValues(alpha: .75),
              fontSize: 16,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 28),
          _MeasurementField(
            controller: weightController,
            label: 'Weight',
            unit: 'g',
          ),
          const SizedBox(height: 16),
          _MeasurementField(
            controller: diameterController,
            label: 'Diameter',
            unit: 'mm',
          ),
          const Spacer(),
        ],
      ),
    ),
  );
}

class _MeasurementField extends StatelessWidget {
  const _MeasurementField({
    required this.controller,
    required this.label,
    required this.unit,
  });
  final TextEditingController controller;
  final String label;
  final String unit;
  @override
  Widget build(BuildContext context) => TextFormField(
    controller: controller,
    keyboardType: const TextInputType.numberWithOptions(decimal: true),
    style: const TextStyle(color: Colors.white),
    validator: (value) => double.tryParse(value ?? '') == null
        ? 'Enter a valid $label in $unit.'
        : null,
    decoration: InputDecoration(
      labelText: label,
      suffixText: unit,
      labelStyle: TextStyle(color: Colors.white.withValues(alpha: .7)),
      suffixStyle: const TextStyle(color: AppColors.gold),
      filled: true,
      fillColor: Colors.white.withValues(alpha: .08),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.white.withValues(alpha: .2)),
      ),
    ),
  );
}

class _CameraBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1A2030), Color(0xFF0A0E14)],
        ),
      ),
      child: CustomPaint(painter: _GridPainter(), size: Size.infinite),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.03)
      ..strokeWidth = 1;
    const spacing = 40.0;
    for (var x = 0.0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (var y = 0.0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({
    required this.onViewStory,
    required this.onVerify,
    this.imagePath,
  });

  final VoidCallback onViewStory;
  final VoidCallback onVerify;
  final String? imagePath;

  @override
  Widget build(BuildContext context) {
    final coin = MockData.morganDollar;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: imagePath == null
                      ? LinearGradient(
                          colors: [Colors.grey.shade300, Colors.grey.shade600],
                        )
                      : null,
                ),
                clipBehavior: Clip.antiAlias,
                child: imagePath == null
                    ? Icon(Icons.monetization_on, color: Colors.grey.shade100)
                    : Image.file(File(imagePath!), fit: BoxFit.cover),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.success,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'MATCH FOUND · ${coin.matchPercent}%',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.success,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      coin.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      coin.metadataLine,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: coin.matchPercent / 100,
              backgroundColor: AppColors.divider,
              color: AppColors.gold,
              minHeight: 4,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: NavyButton(
                  label: 'View its story',
                  icon: Icons.menu_book_outlined,
                  onPressed: onViewStory,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GoldButton(
                  label: 'Verify it',
                  icon: Icons.verified_user_outlined,
                  onPressed: onVerify,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
