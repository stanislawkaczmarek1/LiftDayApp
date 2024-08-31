import 'package:flutter/material.dart';
import 'package:liftday/ui_constants/colors.dart';

class PlansPage extends StatefulWidget {
  const PlansPage({super.key});

  @override
  State<PlansPage> createState() => _PlansPageState();
}

class _PlansPageState extends State<PlansPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Mój plan ",
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTextButton("Zobacz", Icons.remove_red_eye),
                _buildTextButton("Zastąp", Icons.autorenew),
                _buildTextButton("Usuń", Icons.delete),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Dni treningowe",
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                _buildDropdownTile(
                    title: "Dni z planu treningowego", main: false),
                _buildDropdownTile(title: "Inne dni", main: false),
                const SizedBox(height: 10),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text("Dodaj dzień"),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 24),
                    backgroundColor: colorPrimaryButton,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    textStyle: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ],
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
