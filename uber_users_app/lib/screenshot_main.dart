import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uber_users_app/appInfo/app_info.dart';
import 'package:uber_users_app/appInfo/auth_provider.dart';
import 'package:uber_users_app/global/global_var.dart';
import 'package:uber_users_app/models/address_models.dart';
import 'package:uber_users_app/pages/about_page.dart';
import 'package:uber_users_app/pages/home_page.dart';
import 'package:uber_users_app/pages/profile_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Screenshot/demo-only identity. Production main.dart remains unchanged.
  userName = 'Demo User';
  userPhone = '+84 900 123 456';
  userEmail = 'demo.user@example.com';

  runApp(const UserScreenshotApp());
}

class UserScreenshotApp extends StatelessWidget {
  const UserScreenshotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) {
            final appInfo = AppInfoClass();
            appInfo.updatePickUpLocation(
              AddressModel(
                humanReadableAddress: 'Demo pickup location',
                placeName: 'Demo pickup location',
                latitudePosition: 10.7769,
                longitudePosition: 106.7009,
                placeID: 'demo-pickup',
              ),
            );
            return appInfo;
          },
        ),
        ChangeNotifierProvider(create: (_) => AuthenticationProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const UserShowcase(),
      ),
    );
  }
}

class UserShowcase extends StatefulWidget {
  const UserShowcase({super.key});

  @override
  State<UserShowcase> createState() => _UserShowcaseState();
}

class _UserShowcaseState extends State<UserShowcase> {
  int index = 0;

  final pages = const <Widget>[
    HomePage(),
    ProfilePage(),
    AboutPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: index, children: pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (value) => setState(() => index = value),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: 'About'),
        ],
      ),
    );
  }
}
