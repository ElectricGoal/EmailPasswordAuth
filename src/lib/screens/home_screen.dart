import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_app/models/models.dart';
import 'package:login_app/screens/screens.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({Key? key, required this.currentTab}) : super(key: key);

  static MaterialPage page(int currentTab) {
    return MaterialPage(
      name: AppPages.home,
      key: const ValueKey(AppPages.home),
      child: Home(
        currentTab: currentTab,
      ),
    );
  }

  final int currentTab;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static List<Widget> pages = const [
    Tab0Screen(),
    Tab1Screen(),
    Tab2Screen(),
  ];

  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = const UserModel(
    uid: 'None',
    firstName: 'None',
    lastName: 'None',
    email: 'None',
  );

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateManager>(
      builder: (
        context,
        appStateManager,
        child,
      ) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.green,
            title: const Text("App"),
            actions: [
              profileButton(),
            ],
          ),
          body: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection("users")
                .doc(user!.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(
                    //backgroundColor: Colors.greenAccent,
                    color: Colors.greenAccent,
                  ),
                );
              }
              final data = snapshot.data;

              /// Review: should add a check just in case parsing model from json cause
              /// error which will obviously break all the below code.
              switch (snapshot.data) {
                case null:
                  return const Center(
                    child: Text('Something gone wrong'),
                  );
                default:
                  loggedInUser = UserModel.fromMap(data);
                  //print(loggedInUser.firstName);
                  Provider.of<ProfileManager>(context, listen: true)
                      .updateUserData(loggedInUser);
                  return IndexedStack(
                    index: widget.currentTab,
                    children: pages,
                  );
              }
            },
          ),
          bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: Colors.green,
            currentIndex: widget.currentTab,
            onTap: (index) {
              /// Review: can use shortcut like [context.read]
              Provider.of<AppStateManager>(context, listen: false)
                  .goToTab(index);
            },
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                label: 'Chat',
                icon: Icon(Icons.chat),
              ),
              BottomNavigationBarItem(
                label: 'Search',
                icon: Icon(Icons.search),
              ),
              BottomNavigationBarItem(
                label: 'List',
                icon: Icon(Icons.list),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget profileButton() {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: InkWell(
        child: const Icon(
          Icons.account_circle,
          size: 40,
          color: Colors.white,
        ),
        onTap: () {
          Provider.of<ProfileManager>(context, listen: false)
              .onProfilePressed(true);
        },
      ),
    );
  }
}
