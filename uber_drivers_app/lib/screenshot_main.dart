import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uber_drivers_app/global/global.dart';
import 'package:uber_drivers_app/pages/earnings/earning_page.dart';
import 'package:uber_drivers_app/pages/home/home_page.dart';
import 'package:uber_drivers_app/pages/profile/profile_page.dart';
import 'package:uber_drivers_app/pages/trips/trips_page.dart';
import 'package:uber_drivers_app/providers/auth_provider.dart';
import 'package:uber_drivers_app/providers/registration_provider.dart';
import 'package:uber_drivers_app/providers/trips_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  driverName = 'Demo';
  driverSecondName = 'Driver';
  driverPhone = '+92 300 1234567';
  driverEmail = 'demo.driver@example.com';
  address = 'Lahore, Pakistan';
  ratting = '4.8';

  runApp(const ScreenshotShowcaseApp());
}

class ScreenshotShowcaseApp extends StatelessWidget {
  const ScreenshotShowcaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthenticationProvider()),
        ChangeNotifierProvider(create: (_) => RegistrationProvider()),
        ChangeNotifierProvider(create: (_) => TripProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(useMaterial3: true),
        home: const FunctionShowcase(),
      ),
    );
  }
}

class FunctionShowcase extends StatefulWidget {
  const FunctionShowcase({super.key});

  @override
  State<FunctionShowcase> createState() => _FunctionShowcaseState();
}

class _FunctionShowcaseState extends State<FunctionShowcase> {
  int index = 0;

  final pages = <Widget>[
    const HomePage(),
    const EarningsPage(),
    TripsPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: index, children: pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (value) => setState(() => index = value),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.credit_card), label: 'Earnings'),
          BottomNavigationBarItem(icon: Icon(Icons.account_tree), label: 'Trips'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
