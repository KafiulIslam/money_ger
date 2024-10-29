import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mailer/flutter_mailer.dart';
import 'package:money_ger/controllers/auth_provider.dart';
import 'package:money_ger/controllers/monthly_budget_provider.dart';
import 'package:money_ger/controllers/notification_services.dart';
import 'package:money_ger/utils/app_storage.dart';
import 'package:money_ger/utils/assets_path.dart';
import 'package:money_ger/utils/constant/constant.dart';
import 'package:money_ger/utils/custom_dialog.dart';
import 'package:money_ger/utils/spacer.dart';
import 'package:money_ger/utils/typograpgy.dart';
import 'package:money_ger/views/dashboard/dashboard_screen.dart';
import 'package:money_ger/views/dashboard/home/widgets/add_budget_bottomsheet.dart';
import 'package:money_ger/views/dashboard/home/widgets/add_expense_bottomsheet.dart';
import 'package:money_ger/views/dashboard/home/widgets/custom_expansion_tile.dart';
import 'package:money_ger/widgets/components/buttons/primary_button.dart';
import 'package:provider/provider.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:store_redirect/store_redirect.dart';
import '../../../main.dart';
import '../../../utils/color.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //NotificationServices _notificationServices = NotificationServices();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final TextEditingController _currency = TextEditingController();
  late String _selectedCurrencySymbol = '';

  @override
  void initState() {
    final monthlyBudgetState =
    Provider.of<MonthlyBudgetProvider>(context, listen: false);

    NotificationServices.sendDailyNotification((monthlyBudgetState.monthlyBudget -
        monthlyBudgetState.totalMonthlyExpense)
        .toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthProvider, MonthlyBudgetProvider>(
        builder: (_, authState, monthlyBudgetState, child) {
      return Scaffold(
        backgroundColor: scaffoldColor,
        key: _scaffoldKey,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: primeColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32)),
          ),
          automaticallyImplyLeading: false,
          centerTitle: true,
          leading: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: IconButton(
                onPressed: () {
                  _scaffoldKey.currentState?.openDrawer();
                },
                icon: Icon(
                  Icons.menu,
                  color: white,
                )),
          ),
          title: Text(
           // '${AppConstant.currentMonth} History',
            AppConstant.currentMonthId,
            style: tTextStyleBold.copyWith(color: white, fontSize: 20),
          ),
          // actions: [
          //   IconButton(
          //       onPressed: () {
          //         authState.logout(context);
          //       },
          //       icon: const Icon(
          //         Icons.logout,
          //         color: white,
          //       ))
          // ],
        ),
        drawer: _drawer(),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: RefreshIndicator(
            onRefresh: () {
              return monthlyBudgetState.getExpenseList();
            },
            child: Column(
              children: [
                _monthlyBudgetCard(context),
                sixteenVerticalSpace,
                Expanded(
                  child: ListView.separated(
                      itemBuilder: (_, index) {
                        var data = monthlyBudgetState.expenseList[index];
                        return CartExpansionTile(
                          docId: data.docId,
                            monthlyBudgetId: data.monthlyBudgetId,
                            description: data.description,
                            expenseType: data.expenseType,
                            expenseAmount: data.expenseAmount,
                            uid: data.uid,
                            createdAt: data.createdAt);
                      },
                      separatorBuilder: (_, index) => sixteenVerticalSpace,
                      itemCount: monthlyBudgetState.expenseList.length),
                )
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: primeColor,
          onPressed: () {
            CustomDialog.dialogBuilder(context, const AddExpenseBottomSheet());
          },
          child: const Icon(
            Icons.add,
            color: white,
          ),
        ),
      );
    });
  }

  Widget _monthlyBudgetCard(BuildContext context) {
    final monthlyBudgetState =
        Provider.of<MonthlyBudgetProvider>(context, listen: false);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        image: const DecorationImage(
            image: AssetImage(
              'assets/images/budgetCard.png',
            ),
            fit: BoxFit.cover),
        borderRadius: BorderRadius.circular(12),
        // color: secondaryColor
      ),
      child: monthlyBudgetState.isBudgetLoading
          ? Container(
              height: 140,
              width: double.infinity,
              decoration: BoxDecoration(
                image: const DecorationImage(
                    image: AssetImage(
                      'assets/images/budgetCard.png',
                    ),
                    fit: BoxFit.cover),
                borderRadius: BorderRadius.circular(12),
                //color: primeColor
              ),
              child: const Center(child: CircularProgressIndicator()))
          : Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        AppConstant.currentMonth,
                        style:
                            tTextStyleBold.copyWith(fontSize: 18, color: white),
                      ),
                    ),
                    const Spacer(),
                    // InkWell(
                    //   onTap: () {
                    //     CustomDialog.bottomSheet(
                    //         context, const AddBudgetBottomSheet());
                    //   },
                    //   child: CircleAvatar(
                    //     radius: 15,
                    //     backgroundColor: white,
                    //     child: Icon(
                    //       monthlyBudgetState.monthlyBudget == 00
                    //           ? Icons.add
                    //           : Icons.edit,
                    //       size: 20,
                    //       color: secondaryColor,
                    //     ),
                    //   ),
                    // ),
                    InkWell(
                      onTap: () {
                        CustomDialog.dialogBuilder(
                            context, const AddBudgetBottomSheet());
                      },
                      child: Container(
                        height: 36,
                        width: 42,
                        decoration: const BoxDecoration(
                            color: primeColor,
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(12),
                                topRight: Radius.circular(12))),
                        child: Icon(
                          monthlyBudgetState.monthlyBudget == 00
                              ? Icons.add
                              : Icons.edit,
                          size: 20,
                          color: white,
                        ),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Budget',
                            style: tTextStyleBold.copyWith(
                                fontSize: 18, color: white),
                          ),
                          const Spacer(),
                          Text(
                            monthlyBudgetState.monthlyBudget.toString(),
                            style: tTextStyle700.copyWith(
                                fontSize: 16, color: white),
                          ),
                        ],
                      ),
                      eightVerticalSpace,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            // "Balance in ${AppConstant.currentMonth}",
                            "Expense",
                            style: tTextStyleBold.copyWith(
                                fontSize: 18, color: white),
                          ),
                          Text(
                            monthlyBudgetState.totalMonthlyExpense.toString(),
                            style: tTextStyle700.copyWith(
                                fontSize: 16, color: white),
                          ),
                        ],
                      ),
                      eightVerticalSpace,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            // "Balance in ${AppConstant.currentMonth}",
                            "Balance",
                            style: tTextStyleBold.copyWith(
                                fontSize: 18, color: white),
                          ),
                          Text(
                            (monthlyBudgetState.monthlyBudget -
                                    monthlyBudgetState.totalMonthlyExpense)
                                .toString(),
                            style: tTextStyle700.copyWith(
                                fontSize: 16, color: white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Drawer _drawer() {
    return Drawer(
      width: MediaQuery.of(context).size.width / 1.8,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 10,
            ),
            Image.asset(
              splashLogo,
              height: 150,
              width: 150,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 20,
            ),
            _drawerTile(Icons.star, 'Ratings', () async {
              await StoreRedirect.redirect(
                  androidAppId: "com.kafi.money_ger", iOSAppId: "com.kafi.money_ger");
              // showDialog(
              //   context: context,
              //   barrierDismissible: true,
              //   builder: (context) => _dialog,
              // );
            }),
            const Divider(
              color: white,
            ),
            _drawerTile(Icons.feedback_outlined, 'Feedback', () async {
              await FlutterMailer.send(MailOptions(
                body: 'Hi MoneyGer Team,',
                subject: 'Feedback on MoneyGer',
                recipients: ['kafiulislam2022@gmail.com'],
                isHTML: true,
                attachments: [
                  'path/to/image.png',
                ],
              ));
            }),
            const Divider(
              color: white,
            ),
            _drawerTile(Icons.currency_exchange_outlined, 'Currency ($userCurrency)', () async {
              showCurrencyPicker(
                context: context,
                showFlag: true,
                showCurrencyName: true,
                showCurrencyCode: true,
                onSelect: (Currency currency) async {
                  _currency.text = currency.name;
                  _selectedCurrencySymbol = currency.symbol;
                  await storage.write(key: 'currency', value: currency.symbol);
                  getUserCurrency();
                  setState(() {});

                },
              );
            }),
            const Divider(
              color: white,
            ),
            _drawerTile(Icons.logout_outlined, 'Logout', () {
              CustomDialog.dialogBuilder(context, _logoutColumn('Logout','Are you sure, you want to logout ?.'));
            }),
            const Divider(
              color: white,
            ),
            _drawerTile(Icons.delete_outline, 'Delete Account', () {
              CustomDialog.dialogBuilder(context, _logoutColumn('Delete Account','Are you sure, you want to Delete account ?.'));
            }),
          ],
        ),
      ),
    );
  }

  Widget _drawerTile(IconData icon, String title, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Icon(
              icon,
              color: primeColor,
            ),
            sixteenHorizontalSpace,
            Text(title, style: tTextStyle600.copyWith(color: primeColor, fontSize: 16)),
            Spacer(),
            Icon(Icons.arrow_forward_ios, color: primeColor, size: 16,)
          ],
        ),
      ),
    );
  }

  final _dialog = RatingDialog(
    initialRating: 1.0,
    title: const Text(
      '',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 5.0,
        color: black,
        letterSpacing: 1.5,
        fontWeight: FontWeight.bold,
      ),
    ),
    message: const Text(
      'Please rate your MoneyGer experience',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 14,
        color: black,
        letterSpacing: 1,
      ),
    ),
    image: Image.asset(
      splashLogo,
     height: 100,
     width: 100,
     // fit: BoxFit.contain,
    ),
    submitButtonText: 'Submit',
    submitButtonTextStyle: const TextStyle(color: primeColor, fontSize: 16.0),
    commentHint: 'Enter your comment here...',
    onCancelled: () {},
    onSubmitted: (response) async {
      if (response.rating < 2.0) {
      //  CustomSnack.warningSnack('You have to give more than two star!', context);
      } else {
        await StoreRedirect.redirect(
            androidAppId: "com.kafi.money_ger", iOSAppId: "com.kafi.money_ger");
      }
    },
  );

  Widget _logoutColumn(String header, String message) {
    final authState =
    Provider.of<AuthProvider>(context, listen: false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.clear,
                  color: trans,
                )),
            Text(
              header,
              textAlign: TextAlign.center,
              style: tTextStyle500.copyWith(fontSize: 20, color: black),
            ),
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.clear,
                  color: iconColor,
                )),
          ],
        ),
        Text(message),
        sixteenVerticalSpace,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
          Container(
            alignment: Alignment.center,
            height: 35.0,
            width: 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: primeColor,
            ),
            child: TextButton(
              child: Text(
                'Yes',
                style: tTextStyle600.copyWith(color: white, fontSize: 14),
              ),
              onPressed: () async {
                await authState.logout(context);
              },
            ),
          ),
          Container(
            alignment: Alignment.center,
            height: 35.0,
            width: 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: primaryLight,
            ),
            child: TextButton(
              child: Text(
                'No',
                style: tTextStyle600.copyWith(color: primeColor, fontSize: 14),
              ),
              onPressed: () async {
                Navigator.pop(context);
              },
            ),
          ),
        ],),
      ],
    );
  }

  Widget _buildCurrency() {
    return TextFormField(
      controller: _currency,
      onTap: () {
        showCurrencyPicker(
          context: context,
          showFlag: true,
          showCurrencyName: true,
          showCurrencyCode: true,
          onSelect: (Currency currency) {
            setState(() {
              _currency.text = currency.name;
              _selectedCurrencySymbol = currency.symbol;
            });
          },
        );
      },
      autofocus: false,
      cursorColor: primeColor,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        filled: true,
        fillColor: assColor,
        contentPadding: const EdgeInsets.all(16),
        hintText: 'Select your currency',
        hintStyle: hintTextStyle,
        focusedBorder: AppConstant.focusOutLineBorder,
        enabledBorder: AppConstant.enableOutLineBorder,
        errorBorder: AppConstant.outlineErrorBorder,
        focusedErrorBorder: AppConstant.outlineErrorBorder,
        focusColor: secondaryColor,
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

}
