
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:payment_app/core/theme/app_colors.dart';
import 'package:payment_app/core/theme/text_stylies.dart';
import 'package:payment_app/core/utils/app_snackbar.dart';
import 'package:payment_app/features/Amount/screen/add_amount_screen.dart';
import 'package:payment_app/features/scan/widgets/scanShortcuts.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  MobileScannerController cameraController = MobileScannerController();
  bool isFlashOn = false;
  bool _hasNavigated = false; //Prevents duplicate navigation on rapid scans

  // Parse UPI QR and navigate to AddAmountScreen
  void _handleScannedCode(String code) {
    // Guard against scanning the same QR multiple times rapidly
    if (_hasNavigated) return;

    debugPrint("Raw scanned value: $code");

    // Check if it's a UPI payment link
    if (code.startsWith("upi://pay")) {
      final Uri uri = Uri.parse(code);

      // Extract UPI ID (pa) and Person Name (pn)
      final String upiId = uri.queryParameters['pa'] ?? '';
      final String rawName = uri.queryParameters['pn'] ?? '';

      // Decode URL-encoded name e.g. "Vishal%20Chaubey" → "Vishal Chaubey"
      final String userName = Uri.decodeComponent(rawName);

      if (upiId.isEmpty) {
        AppSnackbar.show(context, "Invalid UPI QR code. No UPI ID found.");
        return;
      }

      setState(() => _hasNavigated = true);

      debugPrint("Parsed UPI ID: $upiId");
      debugPrint("Parsed Name: $userName");

      //Navigate to AddAmountScreen with extracted data
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddAmountScreen(
            isFromQR: true,
            userName: userName,
            upiId: upiId,
          ),
        ),
      ).then((_) {
        // Reset navigation guard when user comes back
        setState(() => _hasNavigated = false);
      });

    } else {
      // Not a UPI QR — show raw value or handle other QR types
      AppSnackbar.show(context, "Not a UPI QR code.");
    }
  }

  // Gallery QR picker
  Future<void> selectQRFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    try {
      final BarcodeCapture? result =
          await cameraController.analyzeImage(image.path);

      if (!mounted) return;

      if (result != null && result.barcodes.isNotEmpty) {
        final String? code = result.barcodes.first.rawValue;
        if (code != null) {
          _handleScannedCode(code); // Use same handler
        }
      } else {
        AppSnackbar.show(context, "No QR code detected. Try a clearer photo.");
      }
    } catch (e) {
      debugPrint("Error analyzing image: $e");
      if (mounted) AppSnackbar.show(context, "Failed to read image file.");
    }
  }

  void toggleFlashLight() {
    cameraController.toggleTorch();
    setState(() => isFlashOn = !isFlashOn);
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new, color: blackColor, size: 16.sp),
        ),
        title: Text(
          "Scan any QR code",
          style: AppTextStyles.headingBlackTextStyle.copyWith(fontSize: 14.sp),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.more_vert, color: blackColor, size: 18.sp),
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: cameraController,
            onDetect: (BarcodeCapture capture) {
              final List<Barcode> barcodes = capture.barcodes;

              for (final barcode in barcodes) {
                final String? code = barcode.rawValue;
                if (code != null) {
                  _handleScannedCode(code); 
                  break; // Stop after first valid barcode
                }
              }
            },
          ),

          // Scan frame overlay
          Positioned(
            top: 100.h,
            left: 40.w,
            right: 40.w,
            child: Container(
              width: 250.w,
              height: 250.h,
              decoration: BoxDecoration(
                border: Border.all(color: themeColor, width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),

          // Bottom shortcuts
          Positioned(
            bottom: 150.h,
            left: 0.w,
            right: 0.w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                scanShortcuts(
                  Icons.image_outlined,
                  selectQRFromGallery,
                  "Upload QR",
                ),
                scanShortcuts(
                  Icons.flashlight_on_outlined,
                  toggleFlashLight,
                  "Flashlight",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}