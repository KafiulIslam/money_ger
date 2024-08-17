import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:money_ger/models/expense_model.dart';
import '../utils/constant/appwrite_constant.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/services.dart';
import 'dart:typed_data';


class MonthlyDetailController extends ChangeNotifier {
  MonthlyDetailController() {
    _init();
  }

  Client client = Client();
  late Databases db;

  _init() {
    client
        .setEndpoint(AppWriteConstant.endPoint)
        .setProject(AppWriteConstant.projectId);
    db = Databases(client);

  }


  Future<Uint8List> generatePdf(String monthId, List<ExpenseModel> expenses) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Monthly Expense Report - $monthId', style: pw.TextStyle(fontSize: 24)),
              pw.SizedBox(height: 20),
              pw.Table.fromTextArray(
                headers: ['Description', 'Type', 'Amount', 'Date'],
                data: expenses.map((expense) => [
                  expense.description,
                  expense.expenseType,
                  expense.expenseAmount.toString(),
                  expense.createdAt,
                ]).toList(),
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                'Total: ${expenses.fold<int>(0, (sum, item) => sum + item.expenseAmount)}',
                style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }


  Future<void> sharePdf(String monthId, List<ExpenseModel> expenses) async {
    final pdfData = await generatePdf(monthId, expenses);
    await Printing.sharePdf(bytes: pdfData, filename: 'MonthlyReport_$monthId.pdf');
  }


}
