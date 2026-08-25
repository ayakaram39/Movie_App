import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF242A32),

      appBar: AppBar(
        backgroundColor: const Color(0xFF242A32),
        elevation: 0,
        title: const Text(
          'What do you want to watch?',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(
                hintText: 'Search',
                hintStyle: const TextStyle(
                  color: Colors.grey,
                ),
                suffixIcon: const Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
                filled: true,
                fillColor: const Color(0xFF343A40),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    color: Colors.orange,
                    width: 2,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    color: Colors.orange,
                    width: 2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}