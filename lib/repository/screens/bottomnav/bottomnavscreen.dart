import 'package:flutter/material.dart';
import 'package:houzy/repository/screens/booking/bookingscreen.dart';
import 'package:houzy/repository/screens/help/helpscreen.dart';
import 'package:houzy/repository/screens/home/homescreen.dart';
import 'package:houzy/repository/screens/services/servicesscreen.dart';
import 'package:houzy/repository/screens/account/accountscreen.dart';

class BottomNavScreen extends StatefulWidget {
  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  int currentIndex = 0;

  final List<Widget> pages = [
    HomeScreen(),
    BookingScreen(),
    ServicesScreen(),
    AccountScreen(),
    HelpScreen(),
  ];

  final List<String> icons = [
    "house.png",
    "book-open-text.png",
    "store.png",
    "user.png",
    "circle-help.png"
  ];

  final List<String> labels = [
    "Home",
    "Booking",
    "Services",
    "Account",
    "Help"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: IndexedStack(
        index: currentIndex,
        children: pages,
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BottomNavigationBar(
            currentIndex: currentIndex,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedItemColor: const Color(0XFFF54A00),
            unselectedItemColor: Colors.grey,
            showUnselectedLabels: true,
            onTap: (index) {
              setState(() {
                currentIndex = index;
              });
            },
            items: List.generate(5, (index) {
              bool isSelected = index == currentIndex;
              return BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/images/${icons[index]}',
                  width: isSelected ? 28 : 24,
                  height: isSelected ? 28 : 24,
                  color: isSelected ? const Color(0XFFF54A00) : Colors.grey,
                ),
                label: labels[index],
              );
            }),
          ),
        ),
      ),
    );
  }
}
