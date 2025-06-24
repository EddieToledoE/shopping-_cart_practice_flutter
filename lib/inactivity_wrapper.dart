import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class InactivityWrapper extends StatefulWidget {
  final Widget child;
  final Duration timeout;

  const InactivityWrapper({
    required this.child,
    this.timeout = const Duration(minutes: 5),
    Key? key,
  }) : super(key: key);

  @override
  _InactivityWrapperState createState() => _InactivityWrapperState();
}

class _InactivityWrapperState extends State<InactivityWrapper>
    with WidgetsBindingObserver {
  Timer? _inactiveTimer;
  final secureStorage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _resetTimer();
  }

  void _resetTimer() {
    _inactiveTimer?.cancel();
    _inactiveTimer = Timer(widget.timeout, _handleInactivity);
  }

  Future<void> _handleInactivity() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final token = await user.getIdToken();
      final now = DateTime.now().toIso8601String();

      await secureStorage.write(key: 'lastToken', value: token);
      await secureStorage.write(key: 'lastInactive', value: now);

      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();

      if (context.mounted) {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    }
  }

  @override
  void dispose() {
    _inactiveTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _resetTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: _resetTimer,
      onPanDown: (_) => _resetTimer(),
      child: widget.child,
    );
  }
}
