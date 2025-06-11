import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:houzy/repository/widgets/uihelper.dart';
import 'package:animate_do/animate_do.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart'; // ✅ Import geocoding package

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _location = "Select your location";

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location services are disabled.')),
      );
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permission denied')),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location permissions are permanently denied.')),
      );
      return;
    }

    final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        setState(() {
          _location = place.locality ?? place.subAdministrativeArea ?? "Location found";
        });
      } else {
        setState(() {
          _location = "Unknown location";
        });
      }
    } catch (e) {
      setState(() {
        _location = "Error fetching location";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildTopHeader(context, user),
              _headerImage(),
              _locationCard(),
              _buildServiceSelection(),
              _buildTestimonials(),
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopHeader(BuildContext context, User? user) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 62),
              child: SizedBox(
                width: 130,
                height: 45,
                child: Image.asset("assets/images/houzylogoimage.png"),
              ),
            ),
            IconButton(
              icon: Image.asset('assets/images/notebook.png', height: 24),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  builder: (context) => _ongoingSubscriptionSheet(),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {},
            ),
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  builder: (context) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 16),
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: user?.photoURL != null
                              ? NetworkImage(user!.photoURL!)
                              : const AssetImage('assets/images/placeholder.png') as ImageProvider,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          user?.email ?? 'No email',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 16),
                        ListTile(
                          leading: const Icon(Icons.person),
                          title: const Text('Profile'),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.pushNamed(context, '/account');
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.logout, color: Colors.red),
                          title: const Text('Sign Out', style: TextStyle(color: Colors.red)),
                          onTap: () async {
                            Navigator.pop(context);
                            await FirebaseAuth.instance.signOut();
                            Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
                          },
                        ),
                        const SizedBox(height: 16),
                      ],
                    );
                  },
                );
              },
              child: CircleAvatar(
                radius: 18,
                backgroundImage: user?.photoURL != null
                    ? NetworkImage(user!.photoURL!)
                    : const AssetImage('assets/images/placeholder.png') as ImageProvider,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _headerImage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.asset(
          'assets/images/serviceimage1.png',
          fit: BoxFit.cover,
          width: double.infinity,
          height: 180,
        ),
      ),
    );
  }

  Widget _locationCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GestureDetector(
        onTap: _getCurrentLocation,
        child: Row(
          children: [
            const Icon(Icons.location_on, color: Colors.deepOrange),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                _location,
                style: const TextStyle(fontSize: 16),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceSelection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.count(
        crossAxisCount: 4,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        children: List.generate(8, (index) {
          return Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(12),
                child: const Icon(Icons.cleaning_services, color: Colors.deepOrange),
              ),
              const SizedBox(height: 4),
              const Text("Service", style: TextStyle(fontSize: 12)),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildTestimonials() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text("What Our Customers Say",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 12),
          Text("⭐️⭐️⭐️⭐️⭐️ – Excellent service and very professional."),
          SizedBox(height: 8),
          Text("⭐️⭐️⭐️⭐️⭐️ – My house looks spotless, booking was easy!"),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: const [
          Text("Houzy © 2025", style: TextStyle(color: Colors.grey)),
          SizedBox(height: 4),
          Text("All rights reserved.", style: TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _ongoingSubscriptionSheet() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: const Text("No ongoing subscriptions"),
    );
  }
}
