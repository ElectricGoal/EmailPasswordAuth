import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_app/models/models.dart';
import 'package:login_app/models/user.dart';
import 'package:login_app/screens/screens.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key, required this.user}) : super(key: key);

  static MaterialPage page(UserModel user) {
    return MaterialPage(
      name: AppPages.profilePath,
      key: ValueKey(AppPages.profilePath),
      child: ProfileScreen(
        user: user,
      ),
    );
  }

  final UserModel user;

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.close,
            color: Colors.black,
          ),
          onPressed: () {
            Provider.of<ProfileManager>(context, listen: false)
                .tapOnProfile(false);
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            buildProfile(),
            const Spacer(),
            buildLogoutButton(),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildProfile() {
    return Column(
      children: [
        const Icon(
          Icons.account_circle,
          size: 120,
          color: Colors.amber,
        ),
        const SizedBox(
          height: 16,
        ),
        Text(
          '${widget.user.firstName} ${widget.user.lastName}',
          style: const TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        Text(
          '${widget.user.email} ',
          style: const TextStyle(fontSize: 21),
        ),
      ],
    );
  }

  Widget buildLogoutButton() {
    return SizedBox(
      height: 55,
      child: MaterialButton(
        color: Colors.green,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        child: const Text(
          'Log out',
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () async {
          logout();

          Provider.of<ProfileManager>(context, listen: false)
              .tapOnProfile(false);

          Provider.of<AppStateManager>(context, listen: false).logout();

          Provider.of<ProfileManager>(context, listen: false)
              .logout();
        },
      ),
    );
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }
}
