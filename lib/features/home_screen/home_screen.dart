import 'package:flutter/material.dart';
import 'package:talkbridge/features/home_screen/presentation/widgets/upper_part.dart';
import 'package:talkbridge/features/home_screen/presentation/widgets/lower_part.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            UpperPart(),
            Divider(
              color: Colors.grey,
              height: 2,
              thickness: 8,
            ),
            LowerPart(),
          ],
        ),
      ),
    );
  }
}
