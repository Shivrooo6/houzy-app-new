import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart'; 

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



  Widget _buildServiceSelection() {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Center(
          child: Text(
            "Choose Your Cleaning Service",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 4),
        const Center(
          child: Text(
            "Select the perfect cleaning service for your needs",
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.9,
          children: List.generate(6, (index) {
            return GestureDetector(
              onTap: () {
                _showBottomDrawer(
                  context,
                  "Apartment Cleaning",
                  [
                    "Sweeping, Mopping, Dusting",
                    "Bathroom & Kitchen Cleaning",
                    "Balcony Cleaning",
                  ],
                  "assets/images/cleaning.png",
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.orange.shade200),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 5,
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: Color(0xFFFFF3E0),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.cleaning_services, color: Colors.deepOrange, size: 28),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Apartment Cleaning",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "2-3 hrs approx",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ],
    ),
  );
}


  Widget _buildTestimonials() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            "What Our Customers Say",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),
          _TestimonialCard(
            name: "Sarah Johnson",
            text:
                "Amazing service! My house has never been cleaner. The team is professional and thorough.",
            stars: 5,
          ),
          _TestimonialCard(
            name: "Mike Chen",
            text:
                "Love the convenience and quality. They work around my schedule perfectly.",
            stars: 5,
          ),
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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 400),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Currently Ongoing Subscription",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              const Text("All Current ongoing subscriptions comes here"),
              const SizedBox(height: 12),
              ...List.generate(3, (index) {
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    title: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Service Name"),
                        SizedBox(height: 15),
                        Text("Card Content", style: TextStyle(fontSize: 12)),
                      ],
                    ),
                    trailing: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF54A00),
                        minimumSize: const Size(80, 32),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      ),
                      child: const Text("Detailed View", style: TextStyle(fontSize: 12)),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  void _showBottomDrawer(BuildContext context, String serviceTitle, List<String> features, String imagePath) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(serviceTitle, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Image.asset(imagePath, width: 100, height: 100),
              const SizedBox(height: 12),
              ...features.map((feature) => Text("• $feature")).toList(),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF54A00),
                  minimumSize: const Size.fromHeight(45),
                ),
                child: const Text("Book Now"),
              ),
            ],
          ),
        );
      },
    );
  }
}
class ServiceCard extends StatelessWidget {
  final String serviceTitle;
  final String serviceDescription;
  final String price;
  final String duration;
  final List<String> features;
  final bool isPopular;
  final String imagePath;

  const ServiceCard({
    super.key,
    required this.serviceTitle,
    required this.serviceDescription,
    required this.price,
    required this.duration,
    required this.features,
    this.isPopular = false,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color.fromARGB(255, 255, 114, 54)),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.grey.shade100, spreadRadius: 2, blurRadius: 5),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (isPopular)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFF54A00),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text("Most Popular", style: TextStyle(color: Colors.white, fontSize: 10)),
            ),
          const SizedBox(height: 12),
          Center(
            child: Image.asset(imagePath, width: 100, height: 100, fit: BoxFit.contain),
          ),
          const SizedBox(height: 10),
          Text(serviceTitle, textAlign: TextAlign.center, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(serviceDescription, textAlign: TextAlign.center, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
          const SizedBox(height: 12),
          Text("Starting at \$$price", style: const TextStyle(color: Color(0XFFF54A00), fontSize: 13, fontWeight: FontWeight.bold)),
          Text(duration, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
          const SizedBox(height: 12),
          ...features.map(
            (f) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(f, textAlign: TextAlign.center, style: TextStyle(color: Colors.grey.shade700, fontSize: 15)),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {
              final state = context.findAncestorStateOfType<_HomeScreenState>();
              state?._showBottomDrawer(context, serviceTitle, features, imagePath);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0XFFF54A00),
              minimumSize: const Size.fromHeight(45),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text("Select Service"),
          ),
        ],
      ),
    );
  }
}
class _TestimonialCard extends StatelessWidget {
  final String name;
  final String text;
  final int stars;

  const _TestimonialCard({
    required this.name,
    required this.text,
    required this.stars,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(name),
      subtitle: Text(text),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(stars, (_) => const Icon(Icons.star, color: Colors.amber, size: 16)),
      ),
    );
  }
}


