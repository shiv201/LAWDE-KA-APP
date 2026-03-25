import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';

// NOTE: Add required dependencies in pubspec.yaml:
// firebase_core, firebase_auth, cloud_firestore, firebase_database, geolocator
// Also configure Firebase project files:
// - android/app/google-services.json
// - ios/Runner/GoogleService-Info.plist

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    // TODO: Add Firebase options if required (for web or manual config)
  );

  runApp(SentinelleApp());
}

class SentinelleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sentinelle',
      theme: ThemeData(primarySwatch: Colors.red),
      home: AuthScreen(),
    );
  }
}

// ---------------- AUTH ----------------
class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final emailController = TextEditingController();
  final passController = TextEditingController();

  Future<void> login() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passController.text.trim(),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen()),
      );
    } catch (e) {
      print(e);
    }
  }

  Future<void> register() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passController.text.trim(),
      );
      login();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(controller: emailController, decoration: InputDecoration(labelText: 'Email')),
            TextField(controller: passController, decoration: InputDecoration(labelText: 'Password')),
            SizedBox(height: 20),
            ElevatedButton(onPressed: login, child: Text('Login')),
            ElevatedButton(onPressed: register, child: Text('Register')),
          ],
        ),
      ),
    );
  }
}

// ---------------- HOME ----------------
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;

  final pages = [
    DashboardScreen(),
    TrackingScreen(),
    SafeZoneScreen(),
    SafetyTipsScreen(),
    FeedbackScreen(),
  ];

  Future<void> triggerSOS() async {
    Position position = await Geolocator.getCurrentPosition();

    String userId = FirebaseAuth.instance.currentUser!.uid;

    // 1. Store alert in Firestore
    await FirebaseFirestore.instance.collection('alerts').add({
      'userId': userId,
      'lat': position.latitude,
      'lng': position.longitude,
      'time': DateTime.now().toString(),
    });

    // 2. Start real-time tracking (Realtime DB)
    FirebaseDatabase.instance.ref('tracking/$userId').set({
      'lat': position.latitude,
      'lng': position.longitude,
    });

    // TODO: Add notification logic using Firebase Cloud Messaging

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('SOS Sent'),
        content: Text('Location shared with emergency contacts'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sentinelle')),
      body: pages[_index],
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: triggerSOS,
        child: Icon(Icons.warning),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Tracking'),
          BottomNavigationBarItem(icon: Icon(Icons.shield), label: 'Safe Zone'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Tips'),
          BottomNavigationBarItem(icon: Icon(Icons.feedback), label: 'Feedback'),
        ],
      ),
    );
  }
}

// ---------------- SCREENS ----------------
class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Dashboard'));
  }
}

class TrackingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Google Maps goes here\n// TODO: Add Google Maps API key and implementation',
        textAlign: TextAlign.center,
      ),
    );
  }
}

class SafeZoneScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Geofencing logic here\n// TODO: Implement geofence using location stream',
        textAlign: TextAlign.center,
      ),
    );
  }
}

class SafetyTipsScreen extends StatelessWidget {
  final tips = [
    'Avoid isolated areas',
    'Share your location',
    'Keep emergency numbers ready'
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tips.length,
      itemBuilder: (_, i) => ListTile(title: Text(tips[i])),
    );
  }
}

class FeedbackScreen extends StatelessWidget {
  final controller = TextEditingController();

  Future<void> submit() async {
    await FirebaseFirestore.instance.collection('feedback').add({
      'text': controller.text,
      'time': DateTime.now().toString(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(controller: controller),
          ElevatedButton(
            onPressed: () async {
              await submit();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Submitted')),
              );
            },
            child: Text('Submit'),
          )
        ],
      ),
    );
  }
}
