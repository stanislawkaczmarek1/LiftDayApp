import 'package:flutter/material.dart';
import 'package:liftday/ui_constants/colors.dart';
import 'package:liftday/view/widgets/ui_elements.dart';

class PlansPage extends StatefulWidget {
  const PlansPage({super.key});

  @override
  State<PlansPage> createState() => _PlansPageState();
}

class _PlansPageState extends State<PlansPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: colorPrimaryButton,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: colorMainBackgroud,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Mój plan",
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildTextButton("Zobacz", Icons.remove_red_eye),
                      _buildTextButton("Zastąp", Icons.autorenew),
                      _buildTextButton("Usuń", Icons.delete),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Container for "Dni treningowe" and related widgets
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: colorMainBackgroud,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Dni treningowe",
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  _buildDropdownTile(
                      title: "Dni z planu treningowego", main: false),
                  _buildDropdownTile(title: "Inne dni", main: false),
                  const SizedBox(height: 10),
                  normalButton("+ Dodaj dzień", () {})
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownTile({
    required String title,
    bool isExpanded = false,
    VoidCallback? onExpand,
    required bool main,
  }) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          fontSize: main ? 18.0 : 16.0,
          fontWeight: main ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      trailing: Icon(
        isExpanded ? Icons.expand_less : Icons.expand_more,
      ),
      onTap: onExpand,
    );
  }

  Widget _buildTextButton(String title, IconData icon) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        child: TextButton(
          onPressed: () {
            // Dodaj swoje akcje
          },
          style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: colorPrimaryButton,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              minimumSize: const Size(double.infinity, 0)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 32),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
