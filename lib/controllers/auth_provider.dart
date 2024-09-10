import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import 'package:go_router/go_router.dart';
import 'package:money_ger/routes/route_path.dart';
import '../utils/app_storage.dart';
import '../utils/constant/appwrite_constant.dart';
import '../utils/custom_snack.dart';

class AuthProvider extends ChangeNotifier {
  Client client = Client();

  //late Databases db;
  late Account account;

  // late Storage _appWriteStorage;

  AuthProvider() {
    _init();
  }

  _init() {
    client
        .setEndpoint(AppWriteConstant.endPoint)
        .setProject(AppWriteConstant.projectId);
    account = Account(client);
    //db = Databases(client);
    //_appWriteStorage = Storage(client);
  }

  /// login ///

  late bool isLogin = false;

  Future<void> login(
      String email, String password, BuildContext context) async {
    try {
      isLogin = true;
      notifyListeners();

      var result = await account.createEmailPasswordSession(
          email: email, password: password);

      if (result.userId.isNotEmpty) {
        await storage.write(key: 'sessionId', value: result.$id);
        await storage.write(key: 'userId', value: result.userId);
        context.pushReplacement(RouterPath.dashboard);
        CustomSnack.successSnack('You are logged in successfully', context);
      }
    } catch (e) {
      CustomSnack.warningSnack(e.toString(), context);
    } finally {
      isLogin = false;
      notifyListeners();
    }
  }

  /// sign up ///

  late bool isAccountCreating = false;

  Future<void> signUp(String email, String password, String name,
      String currency, BuildContext context) async {
    try {
      isAccountCreating = true;
      notifyListeners();

      var result = await account.create(
        userId: ID.unique(),
        email: email,
        password: password,
        name: name,
      );
      if (result.$id.isNotEmpty) {
        await storage.write(key: 'currency', value: currency);
        context.go(RouterPath.login);
        CustomSnack.successSnack('Account is created successfully', context);
      }
    } catch (e) {
      CustomSnack.warningSnack(e.toString(), context);
    } finally {
      isAccountCreating = false;
      notifyListeners();
    }
  }

  logout(BuildContext context) async {
    try {
      final res = await account
          .deleteSession(sessionId: 'current')
          .then((onValue) async {
        await storage.delete(key: 'sessionId');
        context.pushReplacement(RouterPath.login);
        CustomSnack.successSnack('You are logged out successfully', context);
      });
    } catch (e) {
      Navigator.pop(context);
      CustomSnack.warningSnack('You are failed to logg out', context);
    }
  }
}
