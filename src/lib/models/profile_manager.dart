import 'package:flutter/cupertino.dart';
import 'package:login_app/models/user.dart';

/// Review: should create a constant for anonymous user
/// E.g

const kAnonymousUser = UserModel(
  uid: 'None',
  firstName: 'None',
  lastName: 'None',
  email: 'None',
);

class ProfileManager extends ChangeNotifier {
  UserModel user = kAnonymousUser;
  UserModel get getUser => user;

  bool _didSelectUser = false;

  bool _darkMode = false;

  bool get didSelectUser => _didSelectUser;

  bool get darkMode => _darkMode;

  /// Review: better naming -> onProfilePressed. Why ? Because it sound like a callback
  /// that will be triggered when profile btn pressed
  void tapOnProfile(bool selected) {
    _didSelectUser = selected;

    notifyListeners();
  }

  /// Review:
  set darkMode(bool darkMode) {
    _darkMode = darkMode;

    notifyListeners();
  }

  /// Review: better naming. [getDataUser] sound like you doing an API
  /// call to get the data which is clearly not what we're doing.
  /// E.g updateUserData
  void getDataUser(UserModel loggedInUser) {
    user = loggedInUser;
  }

  void logout() {
    user = kAnonymousUser;
  }
}
