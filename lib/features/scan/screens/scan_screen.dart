import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:payment_app/core/theme/app_colors.dart';
import 'package:payment_app/core/theme/text_stylies.dart';
import 'package:payment_app/core/utils/app_snackbar.dart';
import 'package:payment_app/features/history/screens/history_screen.dart';
import 'package:payment_app/features/scan/widgets/scanShortcuts.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  MobileScannerController cameraController = MobileScannerController();
  bool isFlashOn = false;

  //function to select QR from gallery
  Future<void> selectQRFromGallery() async {
  final ImagePicker picker = ImagePicker();
  final XFile? image = await picker.pickImage(source: ImageSource.gallery);
  
  if (image == null) return;

  try {
    final BarcodeCapture? result = await cameraController.analyzeImage(image.path);

    if (!mounted) return;

    if (result != null && result.barcodes.isNotEmpty) {
      final String? code = result.barcodes.first.rawValue;
      if (code != null) {
        print("Scanned QR from gallery: $code");
        AppSnackbar.show(context, "QR from gallery: $code");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HistoryScreen()),
        );
      }
    } else {
      // This runs if result is null OR barcodes are empty
      print("DEBUG: Scan failed. Result was: $result");
      AppSnackbar.show(context, "No QR code detected. Try a clearer photo.");
    }
  } catch (e) {
    // This catches the 'Corrupt JPEG' or any native crash
    print("DEBUG: Error analyzing image: $e");
    if (mounted) {
      AppSnackbar.show(context, "Failed to read image file.");
    }
  }
}

  //function for flashlight
  void toggleFlashLight() {
    cameraController.toggleTorch();
    setState(() {
      isFlashOn = !isFlashOn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
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
                  print("Scanned QR: $code");

                  AppSnackbar.show(context, "QR: $code");
                }
              }
            },
          ),
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
