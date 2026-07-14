import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:payment_app/core/theme/app_colors.dart';
import 'package:payment_app/core/theme/theme_provider.dart';
import 'package:payment_app/features/Home/screens/home_screen.dart';
import 'package:payment_app/features/auth/screens/login_screen.dart';
import 'package:payment_app/features/biometrics/security_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp();
  runApp(const ProviderScope(child: MyApp()));
}

// ➔ Changed baseline class to ConsumerWidget to give this access to 'ref'
class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ➔ Actively watch your global theme state manager
    final themeMode = ref.watch(themeModeProvider);

    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          themeMode:
              themeMode, // ➔ Controls whether the app uses theme or darkTheme configurations
          // Baseline Light Mode Configuration
          theme: ThemeData(
            brightness: Brightness.light,
            primaryColor: themeColor,
            scaffoldBackgroundColor: const Color(0xFFF8F9FA),
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.transparent,
              elevation: 0,
              iconTheme: IconThemeData(color: blackColor),
            ),
            cardColor: whiteColor,
          ),

          // Baseline Dark Mode Configuration
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primaryColor: themeColor,
            scaffoldBackgroundColor: const Color(0xFF121212),
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.transparent,
              elevation: 0,
              iconTheme: IconThemeData(color: whiteColor),
            ),
            cardColor: const Color(0xFF1E1E1E),
          ),

          // home: StreamBuilder<User?>(
          //   stream: FirebaseAuth.instance.authStateChanges(),
          //   builder: (context, snapshot) {
          //     if (snapshot.connectionState == ConnectionState.waiting) {
          //       return const Scaffold(
          //         body: Center(child: CircularProgressIndicator()),
          //       );
          //     }

          //     if (snapshot.hasData && snapshot.data != null) {
          //       return const HomeScreen();
          //     }

          //     return const LoginScreen();
          //   },
          // ),
          home: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }

              if (snapshot.hasData && snapshot.data != null) {
                // Inject the Biometric Shield wrapper layer before allowing access to HomeScreen
                return Consumer(
                  builder: (context, ref, child) {
                    final isUnlocked = ref.watch(securityProvider).isUnlocked;

                    if (!isUnlocked) {
                      // Display an asset loader or locked profile window backdrop
                      return Scaffold(
                        body: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.lock_outline,
                                size: 64,
                                color: lightBlueColor,
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () => ref
                                    .read(securityProvider.notifier)
                                    .verifyIdentity(),
                                child: const Text("Unlock Wallet"),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    return const HomeScreen();
                  },
                );
              }
              return const LoginScreen();
            },
          ),
        );
      },
    );
  }
}
