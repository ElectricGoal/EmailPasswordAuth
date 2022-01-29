import 'package:flutter/cupertino.dart';
import 'package:login_app/models/user.dart';

class ProfileManager extends ChangeNotifier {
  UserModel user = UserModel(
    uid: 'None',
    firstName: 'None',
    lastName: 'None',
    email: 'None',
  );
  UserModel get getUser => user;

  bool _didSelectUser = false;

  bool get didSelectUser => _didSelectUser;

  void tapOnProfile(bool selected) {
    _didSelectUser = selected;

    notifyListeners();
  }

  void getDataUser(UserModel loggedInUser) {
    user = loggedInUser;
  }

  void logout() {
    user = UserModel(
      uid: 'None',
      firstName: 'None',
      lastName: 'None',
      email: 'None',
    );
  }
}
