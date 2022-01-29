import 'package:flutter/cupertino.dart';
import 'package:login_app/models/models.dart';
import 'package:login_app/screens/home_screen.dart';
import 'package:login_app/screens/initialize_screen.dart';
import 'package:login_app/screens/login_screen.dart';
import 'package:login_app/screens/register_screen.dart';
import 'package:login_app/screens/screens.dart';

class AppRouter extends RouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  @override
  final GlobalKey<NavigatorState> navigatorKey;

  final AppStateManager appStateManager;
  final ProfileManager profileManager;

  AppRouter({
    required this.appStateManager,
    required this.profileManager,
  }) : navigatorKey = GlobalKey<NavigatorState>() {
    appStateManager.addListener(notifyListeners);
    profileManager.addListener(notifyListeners);
  }

  @override
  void dispose() {
    appStateManager.removeListener(notifyListeners);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      onPopPage: _handlePopPage,
      pages: [
        if (!appStateManager.isInitialized) InitializeScreen.page(),
        if (appStateManager.isInitialized && !appStateManager.isLoggedIn)
          LoginScreen.page(),
        if (appStateManager.isLoggedIn && !appStateManager.isRegistered)
          RegisterScreen.page(),
        if (appStateManager.isLoggedIn && appStateManager.isRegistered)
          Home.page(appStateManager.getSelectedTab),
        if (profileManager.didSelectUser)
          ProfileScreen.page(profileManager.getUser),
      ],
    );
  }

  bool _handlePopPage(
    Route<dynamic> route,
    result,
  ) {
    if (!route.didPop(result)) {
      // 4
      return false;
    }
    if (route.settings.name == AppPages.registerPath) {
      appStateManager.returnToLogin();
    }
    if (route.settings.name == AppPages.profilePath) {
      profileManager.tapOnProfile(false);
    }
    return true;
  }

  @override
  Future<void> setNewRoutePath(configuration) async => null;
}