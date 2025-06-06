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
              _showBookingBottomSheet(context:context);
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
    );
  }

  Widget _bookingCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(19),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromARGB(255, 99, 98, 98)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Expanded(
      child: Text(
        "Full Apartment Cleaning",
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        overflow: TextOverflow.ellipsis,
      ),
    ),
    SizedBox(width: 8),
    Text(
      "Card Action",
      style: TextStyle(color: Colors.grey, fontSize: 14),
    ),
  ],
),

          SizedBox(height: 8),
          Text("4.9 (28k bookings)", style: TextStyle(fontSize: 13)),
          SizedBox(height: 10),
          Text(
            "Full Deep Cleaning of bathrooms and kitchens,\nincluding dusting and vacuuming",
            style: TextStyle(fontSize: 13),
          ),
          SizedBox(height: 15),
          Text("View Details", style: TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

void _showBookingBottomSheet({required BuildContext context}) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
        return Padding(
    padding: const EdgeInsets.all(16.0),
    child: ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: 400,
      ),
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
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("Service Name"),
                      SizedBox(height: 15),
                      Text(
                        "Card Content",
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                  trailing: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF54A00),
                      minimumSize: const Size(80, 32), 
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), 
                    ),
                    child: const Text(
                      "Detailed View",
                      style: TextStyle(fontSize: 12), 
                    ),
                  ),
                ),
              );
            }),

            const SizedBox(height: 6),
            ...List.generate(3, (index) {
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ListTile(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("Service Name"),
                      SizedBox(height: 15), 
                      Text(
                        "Card Content",
                        style: TextStyle(fontSize: 12),
                      ),

                    ],
                  ),
                  trailing: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF54A00),
                      minimumSize: const Size(80, 32), 
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), 
                    ),
                    child: const Text(
                      "Detailed View",
                      style: TextStyle(fontSize: 12), 
                    ),
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
  );
}
