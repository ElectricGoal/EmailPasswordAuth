import 'package:flutter/cupertino.dart';
import 'package:login_app/models/models.dart';
import 'package:login_app/screens/screens.dart';

class ScreenConfig {}

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
        /// Review: use too many bool variables make this code looks super complicated.
        /// Should investigate about [currrentConfiguration] and make use of that configuration
        /// to manage pages
        if (appStateManager.currentAppState == AppState.initialize)
          InitializeScreen.page(),
        if (appStateManager.currentAppState == AppState.logIn)
          LoginScreen.page(),
        if (appStateManager.currentAppState == AppState.register)
          RegisterScreen.page(),
        if (appStateManager.currentAppState == AppState.resetPass)
          ResetPasswordScreen.page(),
        if (appStateManager.currentAppState == AppState.home)
          Home.page(appStateManager.getSelectedTab),
        if (profileManager.didSelectUser)
          ProfileScreen.page(profileManager.getUser),
        // if (!appStateManager.isInitialized) InitializeScreen.page(),
        // if (appStateManager.isInitialized &&
        //     !appStateManager.isLoggedIn &&
        //     !appStateManager.isResetPass)
        //   LoginScreen.page(),
        // if (appStateManager.isResetPass) ResetPasswordScreen.page(),
        // if (appStateManager.isLoggedIn && !appStateManager.isRegistered)
        //   RegisterScreen.page(),
        // if (appStateManager.isLoggedIn && appStateManager.isRegistered)
        //   Home.page(appStateManager.getSelectedTab),
        // if (profileManager.didSelectUser)
        //   ProfileScreen.page(profileManager.getUser),
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
    if (route.settings.name == AppPages.resetPassPath) {
      appStateManager.resetPass(false);
    }
    if (route.settings.name == AppPages.registerPath) {
      appStateManager.goToRegisterScreen(false);
    }
    if (route.settings.name == AppPages.profilePath) {
      profileManager.onProfilePressed(false);
    }
    return true;
  }

  @override
  // ignore: avoid_returning_null_for_void
  Future<void> setNewRoutePath(configuration) async => null;
}
