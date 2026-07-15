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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp();
  runApp(const ProviderScope(child: MyApp()));
}

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
              themeMode, 
          // Baseline Light Mode Configuration
          theme: ThemeData(
            brightness: Brightness.light,
            primaryColor: themeColor,
            // scaffoldBackgroundColor: const Color(0xFFF8F9FA),
            scaffoldBackgroundColor: bgColor,
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

        
          home: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }

              // If logged in, go straight to HomeScreen.
              if (snapshot.hasData && snapshot.data != null) {
                return const HomeScreen();
              }

              return const LoginScreen();
            },
          ),
        );
      },
    );
  }
}
