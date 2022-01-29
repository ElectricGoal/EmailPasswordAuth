import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_app/models/models.dart';
import 'package:login_app/models/user.dart';
import 'package:login_app/screens/screens.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({Key? key, required this.currentTab}) : super(key: key);

  static MaterialPage page(int currentTab) {
    return MaterialPage(
      name: AppPages.home,
      key: ValueKey(AppPages.home),
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

  Future<UserModel> getUserData() async {
    UserModel loggedInUser = UserModel(
      uid: 'None',
      firstName: 'None',
      lastName: 'None',
      email: 'None',
    );
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return loggedInUser;
    }
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .get()
        .then((value) {
      loggedInUser = UserModel.fromMap(value.data());
    });

    return loggedInUser;
  }

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
            title: const Text('App'),
            actions: [
              profileButton(),
            ],
          ),
          body: FutureBuilder<UserModel>(
            future: getUserData(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              final UserModel? loggedInUser = snapshot.data;
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.green,
                    ),
                  );
                default:
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('Some error occurred!'),
                    );
                  } else {
                    if (loggedInUser != null) {
                      Provider.of<ProfileManager>(context, listen: true)
                          .getDataUser(loggedInUser);
                    }
                    return IndexedStack(
                      index: widget.currentTab,
                      children: pages,
                    );
                  }
              }
            },
          ),
          bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: Colors.green,
            currentIndex: widget.currentTab,
            onTap: (index) {
              Provider.of<AppStateManager>(context, listen: false)
                  .goToTab(index);
            },
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                label: 'Tab 0',
                icon: Icon(Icons.explore),
              ),
              BottomNavigationBarItem(
                label: 'Tab 1',
                icon: Icon(Icons.book),
              ),
              BottomNavigationBarItem(
                label: 'Tab 2',
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
          color: Colors.amber,
        ),
        onTap: () {
          Provider.of<ProfileManager>(context, listen: false)
              .tapOnProfile(true);
        },
      ),
    );
  }
}