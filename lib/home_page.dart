import 'package:flutter/material.dart';
import 'dart:math' as math;

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blue.shade300,
        body: Column(
          children: [
            const UpperWidgets(),
            const Center(
              child: Divider(
                color: Colors.grey,
                height: 2,
                thickness: 2,
              ),
            ),
            Column(
              children: [
                Container(
                  color: Colors.white,
                  height: MediaQuery.of(context).size.height * 0.38,
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.flag),
                    ),
                    const Icon(Icons.arrow_forward_outlined),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.flag),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.cached,
                      ),
                    ),
                    const Spacer(),
                    Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.keyboard_voice_outlined,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class UpperWidgets extends StatelessWidget {
  const UpperWidgets({super.key});

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -math.pi,
      child: Column(
        children: [
          Container(
            color: Colors.white,
            height: MediaQuery.of(context).size.height * 0.38,
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.flag),
              ),
              const Icon(Icons.arrow_forward_outlined),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.flag),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.cached,
                ),
              ),
              const Spacer(),
              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.keyboard_voice_outlined,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
