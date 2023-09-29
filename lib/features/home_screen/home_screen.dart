import 'dart:async';

import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:talkbridge/constants/enums.dart';
import 'package:talkbridge/features/home_screen/presentation/widgets/no_network.dart';
import 'package:talkbridge/features/home_screen/presentation/widgets/split_screen.dart';

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
                SplitScreen(
                  user: User.guest,
                ),
                Divider(
                  color: Color.fromARGB(255, 213, 210, 210),
                  height: 2,
                  thickness: 8,
                ),
                SplitScreen(
                  user: User.host,
                ),
              ],
            ),
            if (!hasInternet) const NoNetwork(),
          ],
        ),
      ),
    );
  }
}
