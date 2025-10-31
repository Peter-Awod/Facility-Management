import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:facility_management/shared/constants.dart';
import 'package:facility_management/widgets/login/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'widgets/admin_view/admin_home_view.dart';
import 'widgets/bank_view/bank_home_view.dart';
import 'widgets/technician_view/technician_home_view.dart';

class SplashScreen extends StatefulWidget {
  final FirebaseRemoteConfig remoteConfig;

  const SplashScreen({super.key, required this.remoteConfig});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Future<Widget> _nextScreen;

  @override
  void initState() {
    super.initState();
    _nextScreen = _loadWithDelay();
  }

  /// 🔹 Loads the next screen after version checks
  Future<Widget> _loadWithDelay() async {
    await Future.delayed(const Duration(seconds: 2)); // Splash wait

    // 1️⃣ Check for version update
    final checkResult = await _checkVersion(widget.remoteConfig);

    if (checkResult == VersionStatus.forceUpdate) {
      return const ForceUpdateScreen();
    } else if (checkResult == VersionStatus.softUpdate) {
      // Show soft update dialog but allow use
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showSoftUpdateDialog(context);
      });
    }

    // 2️⃣ Continue to role-based start
    return await getStartPoint();
  }

  /// 🔹 Version check result enum
  Future<VersionStatus> _checkVersion(FirebaseRemoteConfig remoteConfig) async {
    final packageInfo = await PackageInfo.fromPlatform();
    final currentVersion = packageInfo.version;
    final minSupported = remoteConfig.getString('min_supported_version');
    final latest = remoteConfig.getString('latest_version');

    debugPrint("Current Version: $currentVersion");
    debugPrint("Min Supported: $minSupported");
    debugPrint("Latest Version: $latest");

    if (_isVersionLower(currentVersion, minSupported)) {
      return VersionStatus.forceUpdate;
    } else if (_isVersionLower(currentVersion, latest)) {
      return VersionStatus.softUpdate;
    } else {
      return VersionStatus.upToDate;
    }
  }

  /// 🔹 Compare semantic versions (e.g., 1.0.0 vs 1.2.0)
  bool _isVersionLower(String v1, String v2) {
    List<int> a = v1.split('.').map(int.parse).toList();
    List<int> b = v2.split('.').map(int.parse).toList();
    for (int i = 0; i < a.length; i++) {
      if (a[i] < b[i]) return true;
      if (a[i] > b[i]) return false;
    }
    return false;
  }

  /// 🔹 Choose next screen based on user role
  Future<Widget> getStartPoint() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return const LoginScreen();

    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      final role = userDoc.data()?['role'];

      switch (role) {
        case 'admin':
          return const AdminHomeView();
        case 'bank':
          return const BankHomeView();
        case 'technician':
          return const TechnicianHomeView();
        default:
          await FirebaseAuth.instance.signOut();
          return const LoginScreen();
      }
    } catch (e) {
      await FirebaseAuth.instance.signOut();
      return const LoginScreen();
    }
  }

  /// ⚠️ Soft update dialog
  void _showSoftUpdateDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => AlertDialog(
        backgroundColor: kPrimaryColor,
        title: const Text(
          'New Version Available',
          style: TextStyle(color: kSecondaryColor),
        ),
        content: const Text(
          'A newer version of the app is available. Update now to enjoy the latest features and improvements.',
          style: TextStyle(color: kSecondaryColor),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            // Continue using app
            child: const Text('Later',style: TextStyle(color: kTabsColor),),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: kTabsColor),
            onPressed: () async {
              const url =
                  "https://drive.google.com/file/d/1Ylt58n0Wo4zmp_crDeU6FTZHFybusDvk/view?usp=drive_link"; // TODO: change to your APK link
              if (await canLaunchUrl(Uri.parse(url))) {
                await launchUrl(
                  Uri.parse(url),
                  mode: LaunchMode.externalApplication,
                );
              }
            },
            child: const Text('Update',style: TextStyle(color: kPrimaryColor),),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _nextScreen,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: kPrimaryColor,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: kSecondaryColor),
                  SizedBox(height: 20),
                  Text(
                    'Welcome to Facility Management',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: kSecondaryColor,
                      fontSize: 20,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Icon(
                      Icons.scatter_plot_outlined,
                      color: kSecondaryColor,
                      size: 40,
                    ),
                  ),
                ],
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        } else {
          return snapshot.data!;
        }
      },
    );
  }
}

/// 🔹 Force Update Screen (Blocks App)
class ForceUpdateScreen extends StatelessWidget {
  const ForceUpdateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.system_update, color: kSecondaryColor, size: 80),
              const SizedBox(height: 20),
              const Text(
                "Update Required",
                style: TextStyle(
                  color: kSecondaryColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "A new version of the app is required.\nPlease update to continue.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: kSecondaryColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                ),
                onPressed: () async {
                  const url =
                      "https://drive.google.com/file/d/1Ylt58n0Wo4zmp_crDeU6FTZHFybusDvk/view?usp=drive_link"; // TODO: change link
                  if (await canLaunchUrl(Uri.parse(url))) {
                    await launchUrl(
                      Uri.parse(url),
                      mode: LaunchMode.externalApplication,
                    );
                  }
                },
                child: const Text("Update Now"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 🔹 Enum for version check states
enum VersionStatus { upToDate, softUpdate, forceUpdate }
