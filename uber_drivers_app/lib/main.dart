import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:uber_drivers_app/pages/auth/register_screen.dart';
import 'package:uber_drivers_app/pages/dashboard.dart';
import 'package:uber_drivers_app/providers/auth_provider.dart';
import 'package:uber_drivers_app/providers/dashboard_provider.dart';
import 'package:uber_drivers_app/providers/registration_provider.dart';
import 'package:uber_drivers_app/providers/trips_provider.dart';
import 'package:uber_drivers_app/widgets/blocked_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
        ChangeNotifierProvider(create: (_) => AuthenticationProvider()),
        ChangeNotifierProvider(create: (_) => RegistrationProvider()),
        ChangeNotifierProvider(create: (_) => TripProvider()),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        title: 'Uber Drivers App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const AppBootstrap(),
      ),
    );
  }
}

class AppBootstrap extends StatefulWidget {
  const AppBootstrap({super.key});

  @override
  State<AppBootstrap> createState() => _AppBootstrapState();
}

class _AppBootstrapState extends State<AppBootstrap> {
  late final Future<void> _bootstrapFuture;

  @override
  void initState() {
    super.initState();
    _bootstrapFuture = _bootstrap();
  }

  Future<void> _bootstrap() async {
    await Firebase.initializeApp();

    // Do not block the first Flutter frame on Android permission dialogs.
    // Request permissions only after Firebase is ready and the app UI exists.
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        if (await Permission.locationWhenInUse.isDenied) {
          await Permission.locationWhenInUse.request();
        }
        if (await Permission.notification.isDenied) {
          await Permission.notification.request();
        }
      } catch (error, stackTrace) {
        debugPrint('Permission bootstrap failed: $error');
        debugPrintStack(stackTrace: stackTrace);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _bootstrapFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: Colors.black),
            ),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error_outline, size: 48),
                      const SizedBox(height: 16),
                      const Text(
                        'Unable to start the app',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${snapshot.error}',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        return const AuthCheck();
      },
    );
  }
}

class AuthCheck extends StatelessWidget {
  const AuthCheck({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider =
        Provider.of<AuthenticationProvider>(context, listen: false);

    return FutureBuilder<User?>(
      future: FirebaseAuth.instance.authStateChanges().first,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: Colors.black),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return const RegisterScreen();
        }

        return FutureBuilder<bool>(
          future: authProvider.checkIfDriverIsBlocked(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(color: Colors.black),
                ),
              );
            }

            if (snapshot.hasData && snapshot.data == true) {
              return const BlockedScreen();
            }

            return FutureBuilder<bool>(
              future: authProvider.checkDriverFieldsFilled(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(color: Colors.black),
                    ),
                  );
                }

                if (snapshot.hasData && snapshot.data == true) {
                  return const Dashboard();
                }

                return const RegisterScreen();
              },
            );
          },
        );
      },
    );
  }
}
