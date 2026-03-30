import 'package:flutter/material.dart';

void main() {
  runApp(const SentinelleApp());
}

class SentinelleApp extends StatelessWidget {
  const SentinelleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sentinelle',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        primaryColor: Colors.red,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          elevation: 0,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    DashboardScreen(),
    TrackingScreen(),
    SafetyTipsScreen(),
    ReportScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.location_on), label: 'Track'),
          BottomNavigationBarItem(icon: Icon(Icons.security), label: 'Safety'),
          BottomNavigationBarItem(icon: Icon(Icons.report), label: 'Report'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

// ---------------- GLASS CONTAINER ----------------

class GlassContainer extends StatelessWidget {
  final Widget child;

  const GlassContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withOpacity(0.05),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: child,
    );
  }
}

// ---------------- DASHBOARD ----------------

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sentinelle')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // SOS BUTTON
            Center(
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Colors.red, Colors.redAccent],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withOpacity(0.6),
                      blurRadius: 30,
                      spreadRadius: 5,
                    )
                  ],
                ),
                child: const Center(
                  child: Text(
                    'SOS',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // QUICK FEATURES
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: const [
                  FeatureCard(icon: Icons.shield, title: 'Safe Zones'),
                  FeatureCard(icon: Icons.videocam, title: 'Evidence'),
                  FeatureCard(icon: Icons.notifications, title: 'Shake Alert'),
                  FeatureCard(icon: Icons.map, title: 'Live Location'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;

  const FeatureCard({super.key, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: Colors.red),
          const SizedBox(height: 10),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

// ---------------- TRACKING ----------------

class TrackingScreen extends StatelessWidget {
  const TrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Real-time Tracking')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GlassContainer(
          child: const Center(
            child: Text('Map View Placeholder'),
          ),
        ),
      ),
    );
  }
}

// ---------------- SAFETY TIPS ----------------

class SafetyTipsScreen extends StatelessWidget {
  const SafetyTipsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Safety Tips')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          TipCard(title: 'Avoid isolated areas'),
          TipCard(title: 'Keep emergency contacts ready'),
          TipCard(title: 'Share your live location'),
          TipCard(title: 'Stay alert in crowded places'),
        ],
      ),
    );
  }
}

class TipCard extends StatelessWidget {
  final String title;

  const TipCard({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassContainer(
        child: ListTile(
          leading: const Icon(Icons.info, color: Colors.blue),
          title: Text(title),
        ),
      ),
    );
  }
}

// ---------------- REPORT ----------------

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Report Issue')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            GlassContainer(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Describe the issue',
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(12),
                ),
                maxLines: 5,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Submit Report'),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------- PROFILE ----------------

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: const [
            CircleAvatar(radius: 40, backgroundColor: Colors.red, child: Icon(Icons.person, size: 40)),
            SizedBox(height: 10),
            Text('User Name', style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            ListTile(leading: Icon(Icons.phone), title: Text('Emergency Contacts')),
            ListTile(leading: Icon(Icons.settings), title: Text('Settings')),
          ],
        ),
      ),
    );
  }
}
