import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  int selectedSizeIndex = 1;
  bool isPetFriendly = false;
  TextEditingController specialInstructionsController = TextEditingController();

  DateTime? selectedDate;
  String? selectedTimeSlot;

  final List<String> allTimeSlots = [
    '8:00 AM',
    '9:00 AM',
    '10:00 AM',
    '11:00 AM',
    '12:00 PM',
    '1:00 PM',
    '2:00 PM',
    '3:00 PM',
  ];

  final List<String> bookedSlots = ['10:00 AM', '2:00 PM'];

  final List<Map<String, dynamic>> homeSizes = [
    {'label': 'Studio (< 500 sq ft)', 'price': 62},
    {'label': '1 BHK (500-800 sq ft)', 'price': 89},
    {'label': '2 BHK (800-1200 sq ft)', 'price': 125},
    {'label': '3 BHK (1200-1800 sq ft)', 'price': 160},
    {'label': '4+ BHK (1800+ sq ft)', 'price': 205},
  ];

  void _showDatePickerSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Select a Date", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              CalendarDatePicker(
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime(2030),
                onDateChanged: (date) {
                  setState(() => selectedDate = date);
                  Navigator.pop(context);
                  _showTimePickerSheet();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showTimePickerSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Select Time Slot for ${DateFormat('MMMM d, yyyy').format(selectedDate!)}",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 12),
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 3,
                children: allTimeSlots.map((slot) {
                  bool isBooked = bookedSlots.contains(slot);
                  return ElevatedButton(
                    onPressed: isBooked
                        ? null
                        : () {
                            setState(() => selectedTimeSlot = slot);
                            Navigator.pop(context);
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isBooked ? Colors.grey[300] : Colors.orange,
                      foregroundColor: Colors.white,
                    ),
                    child: Text(isBooked ? "$slot\nBooked" : slot, textAlign: TextAlign.center),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
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
          IconButton(icon: const Icon(Icons.shopping_cart_outlined), onPressed: () {}),
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
                      Text(user?.email ?? 'No email'),
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

  @override
  Widget build(BuildContext context) {
    int basePrice = homeSizes[selectedSizeIndex]['price'];
    int totalPrice = isPetFriendly ? basePrice + 25 : basePrice;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTopHeader(context),
            const SizedBox(height: 8),
            const Text("Regular Cleaning", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text("Weekly, bi-weekly, or monthly recurring cleaning service to keep your home consistently clean and fresh."),
            const SizedBox(height: 16),
            Row(
              children: const [
                Chip(label: Text("Same day booking")),
                SizedBox(width: 8),
                Chip(label: Text("Top rated cleaners")),
              ],
            ),
            const SizedBox(height: 20),
            _buildIncluded(),
            const SizedBox(height: 20),
            const Text("Select Your Home Size", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ...List.generate(homeSizes.length, (index) {
              bool isSelected = selectedSizeIndex == index;
              return GestureDetector(
                onTap: () => setState(() => selectedSizeIndex = index),
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.orange[100] : Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: isSelected ? Colors.orange : Colors.transparent),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(homeSizes[index]['label']),
                      Text("\$${homeSizes[index]['price']}", style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 20),
            _buildPetOption(),
            const SizedBox(height: 20),
            const Text("Special Instructions", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: specialInstructionsController,
              decoration: InputDecoration(
                hintText: "e.g., Please focus on the kitchen...",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            const Text("Booking Summary", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _buildBookingSummary(homeSizes[selectedSizeIndex]['label'], totalPrice),
            const SizedBox(height: 16),
            if (selectedDate != null)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _showDatePickerSheet,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, padding: const EdgeInsets.all(14)),
                child: const Text("Continue to Scheduling", style: TextStyle(fontSize: 16)),
              ),
            ),
            const SizedBox(height: 16),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildPetOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Pet-Friendly Service", style: TextStyle(fontWeight: FontWeight.bold)),
              Text("Extra care around pets, pet hair removal, and pet-safe products"),
            ],
          ),
        ),
        Row(
          children: [
            const Text("+\$25"),
            const SizedBox(width: 10),
            Switch(value: isPetFriendly, onChanged: (val) => setState(() => isPetFriendly = val)),
          ],
        ),
      ],
    );
  }

  Widget _buildIncluded() {
    const included = [
      "Dusting all surfaces and furniture",
      "Vacuuming carpets and rugs",
      "Mopping hard floors",
      "Kitchen cleaning (counters, sink, stovetop)",
      "Bathroom cleaning (toilet, sink, shower/tub)",
      "Emptying trash bins",
      "Making beds",
    ];
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: included.map((item) => Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 20),
            const SizedBox(width: 8),
            Expanded(child: Text(item)),
          ],
        )).toList(),
      ),
    );
  }

  Widget _buildBookingSummary(String sizeLabel, int price) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          _summaryRow("Service", "Regular Cleaning"),
          _summaryRow("Size", sizeLabel),
          if (selectedDate != null)
            _summaryRow("Date", DateFormat('MMM d, yyyy').format(selectedDate!)),
          if (selectedTimeSlot != null)
            _summaryRow("Time", selectedTimeSlot!),
          const Divider(),
          _summaryRow("Total", "\$$price", isBold: true),
          const SizedBox(height: 6),
          const Text("One-time payment", style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Column(
      children: const [
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.star, color: Colors.orange),
            Icon(Icons.star, color: Colors.orange),
            Icon(Icons.star, color: Colors.orange),
            Icon(Icons.star, color: Colors.orange),
          ],
        ),
        SizedBox(height: 4),
        Text("Satisfaction guaranteed"),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.lock, size: 16),
            SizedBox(width: 4),
            Text("Secure payment & insured cleaners"),
          ],
        ),
        Divider(height: 30, color: Colors.grey),
        Text("Houzy", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange)),
        SizedBox(height: 4),
        Text("Professional cleaning services you can trust"),
        SizedBox(height: 6),
        Text("Privacy Policy    Terms of Service    Contact Us", style: TextStyle(fontSize: 12)),
        SizedBox(height: 30),
      ],
    );
  }
}