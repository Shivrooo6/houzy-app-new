import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:houzy/repository/widgets/uihelper.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildTopHeader(context),
              _buildServiceSelection(),
              _buildTestimonials(),
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopHeader(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 62),
                child: SizedBox(
                  width: 130, // smaller width
                  height: 45, // smaller height
                  child: UiHelper.CustomImage(img: "houzylogoimage.png"),
                ),
              ),

              IconButton(
                icon: UiHelper.CustomImage(img: 'notebook.png'),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                    ),
                    builder: (context) => _ongoingSubscriptionSheet(),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  // Handle cart logic here
                },
              ),
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
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
                                : const AssetImage(
                                        'assets/images/placeholder.png',
                                      )
                                      as ImageProvider,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            user?.email ?? 'No email',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
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
                            leading: const Icon(
                              Icons.logout,
                              color: Colors.red,
                            ),
                            title: const Text(
                              'Sign Out',
                              style: TextStyle(color: Colors.red),
                            ),
                            onTap: () async {
                              Navigator.pop(context);
                              await FirebaseAuth.instance.signOut();
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                '/login',
                                (route) => false,
                              );
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
                      : const AssetImage('assets/images/placeholder.png')
                            as ImageProvider,
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),
          const Text(
            "Professional",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          const Text(
            "House Cleaning",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0XFFF54A00),
            ),
          ),
          Row(
            children: const [
              Text(
                "Service You Can ",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                "Trust",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 34, 255, 96), // Light green
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),
          const Text(
            "Book trusted, top-rated cleaners in your area. Flexible scheduling, eco-friendly products, and 100% satisfaction guaranteed.",
            style: TextStyle(color: Colors.black54, fontSize: 12),
          ),
          const SizedBox(height: 16),
            Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
              width: 130,
              decoration: BoxDecoration(
                // border: Border.all(color: Colors.grey.shade300), // Removed border
                borderRadius: BorderRadius.circular(6),
                color: Color(0xFFE6F4EA), // Light green
              ),
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 7),
              child: Row(
                children: [
                Icon(
                  Icons.verified_user,
                  color: Color(0XFFF54A00),
                  size: 13,
                ),
                SizedBox(width: 2),
                Flexible(
                  child: Text(
                  "Insured & Bonded",
                  key: Key("insured_bonded"),
                  style: TextStyle(fontSize: 9, color: Colors.black54),
                  overflow: TextOverflow.ellipsis,
                  ),
                ),
                ],
              ),
              ),
              SizedBox(width: 15), // Decreased from 4 to 2 for less spacing
              Container(
              width: 150,
              decoration: BoxDecoration(
                // border: Border.all(color: Colors.grey.shade300), // Removed border
                borderRadius: BorderRadius.circular(6),
                color: Color(0xFFE6F4EA), // Light green
              ),
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 7),
              child: Row(
                children: [
                Icon(Icons.star, color: Color(0XFFF54A00), size: 14),
                SizedBox(width: 2),
                Flexible(
                  child: Text(
                  "4.9★ Avgerage Rating",
                  key: Key("avg_rating"),
                  style: TextStyle(fontSize: 9, color: Colors.black54),
                  overflow: TextOverflow.ellipsis,
                  ),
                ),
                ],
              ),
              ),
            ],
            ),
            const SizedBox(height: 6),
            Row(
            children: [
              Container(
              width: 140,
              decoration: BoxDecoration(
                // border: Border.all(color: Colors.grey.shade300), // Removed border
                borderRadius: BorderRadius.circular(6),
                color: Color(0xFFE6F4EA), // Light green
              ),
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 7),
              child: Row(
                children: [
                Icon(Icons.flash_on, color: Color(0XFFF54A00), size: 13),
                SizedBox(width: 2),
                Flexible(
                  child: Text(
                  "Same Day Booking",
                  key: Key("same_day_booking"),
                  style: TextStyle(fontSize: 9, color: Colors.black54),
                  overflow: TextOverflow.ellipsis,
                  ),
                ),
                ],
              ),
              ),
            ],
            ),

          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              'assets/images/servicesimage.png',
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceSelection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center, // Center align all items
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
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ServiceCard(
                    serviceTitle: "Apartment Cleaning",
                    serviceDescription: "2BHK / 3BHK / Villa",
                    price: "149",
                    duration: "2-3 hours approx",
                    features: [
                      "Sweeping, Mopping, Dusting",
                      "Bathroom & Kitchen Cleaning",
                      "Balcony Cleaning",
                    ],
                    isPopular: true,
                    imagePath: "assets/images/cleaning.png",
                  ),
                  ServiceCard(
                    serviceTitle: "Apartment Cleaning",
                    serviceDescription: "2BHK / 3BHK / Villa",
                    price: "149",
                    duration: "2-3 hours approx",
                    features: [
                      "Sweeping, Mopping, Dusting",
                      "Bathroom & Kitchen Cleaning",
                      "Balcony Cleaning",
                    ],
                    isPopular: true,
                    imagePath: "assets/images/cleaning.png",
                  ),
                  ServiceCard(
                    serviceTitle: "Apartment Cleaning",
                    serviceDescription: "2BHK / 3BHK / Villa",
                    price: "149",
                    duration: "2-3 hours approx",
                    features: [
                      "Sweeping, Mopping, Dusting",
                      "Bathroom & Kitchen Cleaning",
                      "Balcony Cleaning",
                    ],
                    isPopular: true,
                    imagePath: "assets/images/cleaning.png",
                  ),
                ],
              ),
            ),
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
        children: [
          const Text(
            "What Our Customers Say",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
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
      padding: const EdgeInsets.symmetric(horizontal: 1),
      child: Column(
        children: const [
          SizedBox(height: 8),
          Text(
            "Houzy",
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Color(0XFFF54A00),
            ),
          ),
          SizedBox(height: 4),
          Text("Professional cleaning services you can trust"),
          SizedBox(height: 2),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 4,
            children: [
              Text(" Privacy Policy"),
              Text("•"),
              Text("Terms of Service"),
              Text("• Contact Us"),
            ],
          ),
          SizedBox(height: 10),
        ],
      ),
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
          BoxShadow(
            color: Colors.grey.shade100,
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isPopular)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFF54A00),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                "Most Popular",
                style: TextStyle(color: Colors.white, fontSize: 10),
              ),
            ),
          const SizedBox(height: 12),

          // ✅ Display Image Here
          Center(
            child: Image.asset('assets/images/house.png',
              // Use the imagePath variable if you want to make it dynamic
              // imagePath: imagePath,
              // If you want to use a network image, you can use NetworkImage instead   
              height: 30,
              width: 30,
              fit: BoxFit.contain,
            ),
            ),

          const SizedBox(height: 10),
          Center(
            child: Text(
              serviceTitle,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 4),
          Center(
            child: Text(
              serviceDescription,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Text(
              "Starting at \$$price",
              style: const TextStyle(
                color: Color(0XFFF54A00),
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Center(
            child: Text(
              duration,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
            ),
          ),
          const SizedBox(height: 12),
            Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: features
              .map(
                (f) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                    f,
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 15),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textScaleFactor: 0.9,
                    // Adjust text scale factor for smaller text
                    textAlign: TextAlign.center,
                    ),
                  ),
                  ],
                ),
                ),
              )
              .toList(),
            ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {
              _showBottomDrawer(context, serviceTitle, features, imagePath);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0XFFF54A00),
              minimumSize: const Size.fromHeight(45),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text("Select Service"),
          ),
        ],
      ),
    );
  }

  void _showBottomDrawer(
    BuildContext context,
    String title,
    List<String> features,
    String imagePath,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.95,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            color: Colors.transparent,
          ),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                child: Image.asset(
                  imagePath,
                  height: double.infinity,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                    color: Colors.black.withOpacity(0.4),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Center(
                      child: Container(
                        height: 5,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Colors.white60,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: const [
                              Text(
                                "Rating: ",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Icon(Icons.star, color: Colors.green, size: 18),
                              SizedBox(width: 4),
                              Text(
                                "4.9",
                                style: TextStyle(color: Colors.green),
                              ),
                              SizedBox(width: 4),
                              Text("(28k)"),
                            ],
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "Daily cleaning for your entire apartment\nLorem ipsum dolor sit amet consectetur adipisicing elit. Dicta atque laudantium aliquid perferendis sint fuga consequuntur iste, mollitia hic sed ipsam nisi.",
                            style: TextStyle(fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0XFFF54A00),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: const Text("Book Now"),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.white),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: const Text(
                              "Need Time",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        );
      },
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
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: List.generate(
                stars,
                (_) =>
                    const Icon(Icons.star, color: Color(0XFFF54A00), size: 16),
              ),
            ),
            const SizedBox(height: 6),
            Text('"$text"'),
            const SizedBox(height: 6),
            Text(
              "- $name",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _ongoingSubscriptionSheet() {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: 400, // limit height so it won't overflow the screen
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
                      Text("Card Content", style: TextStyle(fontSize: 12)),
                    ],
                  ),
                  trailing: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF54A00),
                      minimumSize: const Size(
                        80,
                        32,
                      ), // smaller width and height
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ), // adjust padding if needed
                    ),
                    child: const Text(
                      "Detailed View",
                      style: TextStyle(fontSize: 12), // smaller text size
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
                      SizedBox(height: 15), // Add vertical space here
                      Text("Card Content", style: TextStyle(fontSize: 12)),
                    ],
                  ),
                  trailing: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF54A00),
                      minimumSize: const Size(
                        80,
                        32,
                      ), // smaller width and height
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ), // adjust padding if needed
                    ),
                    child: const Text(
                      "Detailed View",
                      style: TextStyle(fontSize: 12), // smaller text size
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