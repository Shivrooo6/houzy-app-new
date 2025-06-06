import 'package:flutter/material.dart';

// ServiceCard widget: reusable card for a single service
class ServiceCard extends StatelessWidget {
  final String imagePath;
  final String serviceTitle;
  final String serviceDescription;
  final List<String> features;
  final bool isPopular;

  const ServiceCard({
    super.key,
    required this.imagePath,
    required this.serviceTitle,
    required this.serviceDescription,
    required this.features,
    this.isPopular = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      shadowColor: Colors.grey.withOpacity(0.3),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    imagePath,
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        serviceTitle,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        serviceDescription,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[700],
                            ),
                      ),
                    ],
                  ),
                ),
                if (isPopular)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.deepOrange,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      "Popular",
                      style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: features
                  .map(
                    (feature) => Chip(
                      label: Text(feature),
                      backgroundColor: Colors.grey[200],
                      labelStyle: const TextStyle(fontSize: 12),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

// ServicesScreen widget: lists multiple ServiceCards
class ServicesScreen extends StatelessWidget {
  const ServicesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final services = [
      {
        'imagePath': 'assets/images/service1.png',
        'title': 'Cleaning',
        'description': 'House and office cleaning',
        'features': ['Affordable', 'Reliable', 'Experienced'],
        'isPopular': true,
      },
      {
        'imagePath': 'assets/images/service2.png',
        'title': 'Plumbing',
        'description': 'Fix leaks and pipes',
        'features': ['24/7 Service', 'Certified plumbers'],
        'isPopular': false,
      },
      // Add more service entries as needed here
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Services')),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: services.map((service) {
          return ServiceCard(
            imagePath: service['imagePath'] as String,
            serviceTitle: service['title'] as String,
            serviceDescription: service['description'] as String,
            features: (service['features'] as List<String>),
            isPopular: service['isPopular'] as bool,
          );
        }).toList(),
      ),
    );
  }
}
