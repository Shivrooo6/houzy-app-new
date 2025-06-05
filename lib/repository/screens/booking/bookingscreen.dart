import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BookingScreen extends StatelessWidget {
  const BookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildTopHeader(context),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Full Home Cleaning',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    Icon(Icons.star, color: Colors.orange, size: 18),
                    SizedBox(width: 4),
                    Text("4.9 (28k bookings)", style: TextStyle(fontSize: 14)),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Monthly Subscription",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: 6,
                itemBuilder: (context, index) => _bookingCard(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopHeader(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Image.asset('assets/images/houzylogoimage.png', height: 30),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.note_alt_outlined),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                builder: (context) => const SizedBox(
                  height: 200,
                  child: Center(child: Text("Ongoing Subscriptions")),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () {
              // Cart functionality
            },
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
                          Navigator.pushNamed(context, 'Account Screen');
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
    );
  }

  Widget _bookingCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Full Apartment Cleaning", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
              Text("Card Action", style: TextStyle(color: Colors.grey)),
            ],
          ),
          SizedBox(height: 4),
          Text("4.9 (28k bookings)", style: TextStyle(fontSize: 13)),
          SizedBox(height: 4),
          Text(
            "Full Deep Cleaning of bathrooms and kitchens\n,including dusting and vacuuming",
            style: TextStyle(fontSize: 13),
          ),
          SizedBox(height: 8),
          Text("View Details", style: TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
