import 'package:click_happysoft_app/constants/scaffolds/primary_scaffold.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return PrimaryScaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 6,
          mainAxisSpacing: 6,
          children: const [
            PowerBiCard(value: "\$12,430", caption: "No of Customers"),
            PowerBiCard(value: "1,245", caption: "No of Orders"),
            PowerBiCard(value: "320", caption: "No of Products"),
            PowerBiCard(value: "", caption: ""),
          ],
        ),
      ),
    );
  }
}

class PowerBiCard extends StatelessWidget {
  final String value;
  final String caption;

  const PowerBiCard({
    super.key,
    required this.value,
    required this.caption,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Value (large, bold, like Power BI metric)
            Text(
              value,
              style: const TextStyle(
                fontSize: 32, // Bigger number
                fontWeight: FontWeight.w600,
                color: Colors.black, // Strong dark text
              ),
            ),
            const SizedBox(height: 6),
            // Caption (small, grey, like Power BI label)
            Text(
              caption,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.grey, // Muted caption
              ),
            ),
          ],
        ),
      ),
    );
  }
}
