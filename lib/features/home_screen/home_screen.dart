import 'dart:async';

import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:talkbridge/features/home_screen/presentation/widgets/upper_part.dart';
import 'package:talkbridge/features/home_screen/presentation/widgets/lower_part.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late StreamSubscription<InternetConnectionStatus> _internetSubscription;
  bool hasInternet = true;

  @override
  void initState() {
    super.initState();
    _internetSubscription =
        InternetConnectionChecker().onStatusChange.listen((status) {
      if (status == InternetConnectionStatus.disconnected) {
        setState(() {
          hasInternet = false;
        });
      } else {
        setState(() {
          hasInternet = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _internetSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            const Column(
              children: [
                UpperPart(),
                Divider(
                  color: Color.fromARGB(255, 213, 210, 210),
                  height: 2,
                  thickness: 8,
                ),
                LowerPart(),
              ],
            ),
            if (!hasInternet)
              Container(
                color: Colors.grey.withOpacity(0.8),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.wifi_off_outlined,
                      color: Colors.white,
                      size: 60,
                    ),
                    SizedBox(height: 40),
                    Text(
                      'No network connection',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        'Please turn on Internet and appliaction will refresh',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
