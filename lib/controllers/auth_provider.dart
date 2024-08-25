import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import 'package:money_ger/views/auth/login/login_screen.dart';
import 'package:money_ger/views/dashboard/dashboard_screen.dart';
import '../utils/app_storage.dart';
import '../utils/constant/appwrite_constant.dart';
import '../utils/custom_snack.dart';
import '../views/dashboard/home/home_screen.dart';

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
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => DashboardScreen()));
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

  Future<void> signUp(
      String email, String password, String name, BuildContext context) async {
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
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => const LoginScreen()));
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
      final sessionId = await storage.read(key: 'sessionId');
      final res = await account.deleteSession(sessionId: sessionId!);
      await storage.deleteAll();

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => LoginScreen()));
    } catch (e) {
      CustomSnack.warningSnack('You are logged out successfully', context);
    }
  }
}
