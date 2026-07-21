import 'dart:io';

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
  bool _showResult = false;
  bool _isIdentifying = false;
  XFile? _pickedImage;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _pickedImage = image;
        _isIdentifying = true;
        _showResult = false;
      });

      // Simulate identification process
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        setState(() {
          _isIdentifying = false;
          _showResult = true;
        });
      }
    }
  }

  void _onCapture() async {
    setState(() {
      _pickedImage = null;
      _isIdentifying = true;
      _showResult = false;
    });

    // Simulate identification process
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isIdentifying = false;
        _showResult = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E14),
      body: Stack(
        fit: StackFit.expand,
        children: [
          _CameraBackground(),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      CircleIconButton(
                        icon: Icons.close,
                        onPressed: () => Navigator.of(context).pop(),
                        backgroundColor: Colors.black45,
                        iconColor: Colors.white,
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: _isIdentifying ? AppColors.gold : Colors.white24,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _isIdentifying ? 'Identifying...' : 'Ready to scan',
                              style: const TextStyle(color: Colors.white, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      const CircleIconButton(
                        icon: Icons.flash_off_outlined,
                        backgroundColor: Colors.black45,
                        iconColor: Colors.white,
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: 260,
                  height: 260,
                  child: CustomPaint(
                    painter: _ScanCirclePainter(isIdentifying: _isIdentifying),
                    child: Center(
                      child: _pickedImage == null
                          ? Container(
                              width: 180,
                              height: 180,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [
                                    Colors.grey.shade300,
                                    Colors.grey.shade500,
                                    Colors.grey.shade700,
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.gold.withValues(alpha: 0.3),
                                    blurRadius: 30,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.monetization_on,
                                size: 80,
                                color: Colors.grey.shade200,
                              ),
                            )
                          : Container(
                              width: 180,
                              height: 180,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: FileImage(File(_pickedImage!.path)),
                                  fit: BoxFit.cover,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.gold.withValues(alpha: 0.3),
                                    blurRadius: 30,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                            ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 16),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.info_outline, size: 16, color: AppColors.gold),
                      const SizedBox(width: 6),
                      Text(
                        'Align the coin inside the circle',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(flex: 2),
                if (_showResult) _ResultCard(
                  onViewStory: () => widget.onViewStory(context),
                  onVerify: () => widget.onVerify(context),
                  imagePath: _pickedImage?.path,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(40, 16, 40, 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleIconButton(
                        icon: Icons.photo_library_outlined,
                        backgroundColor: Colors.white24,
                        iconColor: Colors.white,
                        size: 48,
                        onPressed: _pickImage,
                      ),
                      GestureDetector(
                        onTap: _onCapture,
                        child: Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 4),
                            color: Colors.white24,
                          ),
                          child: Center(
                            child: _isIdentifying
                                ? const SizedBox(
                                    width: 40,
                                    height: 40,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 3,
                                    ),
                                  )
                                : const CircleAvatar(
                                    radius: 28,
                                    backgroundColor: Colors.white,
                                  ),
                          ),
                        ),
                      ),
                      CircleIconButton(
                        icon: Icons.flip_camera_ios_outlined,
                        backgroundColor: Colors.white24,
                        iconColor: Colors.white,
                        size: 48,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
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
      child: CustomPaint(
        painter: _GridPainter(),
        size: Size.infinite,
      ),
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

class _ScanCirclePainter extends CustomPainter {
  _ScanCirclePainter({this.isIdentifying = false});

  final bool isIdentifying;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 4;

    final circlePaint = Paint()
      ..color = isIdentifying ? AppColors.success : AppColors.gold
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(center, radius, circlePaint);

    final linePaint = Paint()
      ..color = (isIdentifying ? AppColors.success : AppColors.gold).withValues(alpha: 0.6)
      ..strokeWidth = 1;
    canvas.drawLine(
      Offset(center.dx - radius * 0.6, center.dy + radius * 0.3),
      Offset(center.dx + radius * 0.6, center.dy + radius * 0.3),
      linePaint,
    );
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
