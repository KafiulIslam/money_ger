import 'package:go_router/go_router.dart';
import 'package:money_ger/routes/route_path.dart';
import 'package:money_ger/views/auth/login/login_screen.dart';
import 'package:money_ger/views/auth/signup/signup_screen.dart';
import 'package:money_ger/views/dashboard/dashboard_screen.dart';
import 'package:money_ger/views/dashboard/history/monthlyDetail/monthly_detail.dart';
import '../splash_screen.dart';

class AppRoutes {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => SplashScreen(),
      ),
      GoRoute(
        path: RouterPath.login,
        builder: (context, state) => LoginScreen(),
      ),
      GoRoute(
        path: RouterPath.signup,
        builder: (context, state) => SignUpScreen(),
      ),
      GoRoute(
        path: RouterPath.dashboard,
        builder: (context, state) => DashboardScreen(),
        routes: [
          GoRoute(
            path: RouterPath.monthlyDetail,
            name: RouterPath.monthlyDetail,
            builder: (context, state) {
              MonthlyDetail detail = state.extra as MonthlyDetail;
              return MonthlyDetail(
                  monthId: detail.monthId, expensesList: detail.expensesList);
            },
          ),
        ],
      ),
    ],
  );
}
