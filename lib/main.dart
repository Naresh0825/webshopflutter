import 'package:flutter/services.dart';

import 'package:webshop/commons/exporter.dart';

import 'main_page.dart';
import 'provider/valid_mac_service.dart';
import 'view/agent/provider/add_agent_provider.dart';
import 'view/agent/provider/agent_statement_provider.dart';
import 'view/agent/provider/get_agent_due_provider.dart';
import 'view/agent/provider/post_business_agent_provider.dart';
import 'view/brand/provider/brand_provider.dart';
import 'view/cash_in_cash_out/provider/cash_book_provider.dart';
import 'view/cash_in_cash_out/provider/cash_in_cash_out_provider.dart';
import 'view/cash_in_cash_out/provider/edit_cash_in_out_provider.dart';
import 'view/group/provider/group_provider.dart';
import 'view/login/services/login_service.dart';
import 'view/purchase/services/delete_purchase_service.dart';
import 'view/purchase/services/purchase_by_id_service.dart';
import 'view/purchase/services/purchase_service.dart';
import 'view/purchase/services/update_purchase_provider.dart';
import 'view/purchase_return/provider/purchase_bill_number_provider.dart';
import 'view/sales/services/delete_sales_service.dart';
import 'view/sales/services/find_sale_service.dart';
import 'view/sales/services/sales_report_service.dart';
import 'view/sales/services/sales_service.dart';
import 'view/sales/services/update_sales_provider.dart';
import 'view/sales_return/provider/get_salesbyid_provider.dart';
import 'view/sales_return/provider/post_sales_return.dart';
import 'view/sales_return/provider/sales_return_provider.dart';
import 'view/stock/reports/providers/stock_statement_provider.dart';
import 'view/stock/reports/providers/stock_summary_provider.dart';
import 'view/stock/services/add_stock_provider.dart';
import 'view/stock/services/get_stock_detail_provider.dart';
import 'view/stock/services/stock_details_provider.dart';
import 'view/supplier/provider/add_supplier_provider.dart';
import 'view/supplier/provider/get_supplier_due.dart';
import 'view/supplier/provider/post_business_supplier_provider.dart';
import 'view/supplier/provider/supplier_satement_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) async {
    sharedPref = await SharedPreferences.getInstance();
    runApp(const WebShop());
  });
}

class WebShop extends StatelessWidget {
  const WebShop({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ConnectivityProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => LoginServiceProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ValidMacAddressProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => TabletSetupServiceProvider(),
        ),

        //stock
        ChangeNotifierProvider(
          create: (context) => GroupProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => AddRemoveStockProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => BrandProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => StockSummaryServiceProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => StockStatementServiceProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => StockDetailServiceProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => GetStockListProvider(),
        ),

        //sale
        ChangeNotifierProvider(
          create: (context) => SaleSummaryServiceProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => GetSalesByIdProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => SalesReportServiceProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => SalesServiceProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => UpdateSalesProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => DeleteSalesServiceProvider(),
        ),

        //Sales Return
        ChangeNotifierProvider(
          create: (context) => SalesReturnServiceProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => PostSaleReturnProvider(),
        ),

        //purchase
        ChangeNotifierProvider(
          create: (context) => PurchaseServiceProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => PurchaseByIdServiceProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => DeletePurchaseServiceProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => UpdatePurchaseServiceProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => PurchaseByBillNumberServiceProvider(),
        ),

        //Supplier
        ChangeNotifierProvider(
          create: (context) => AddSupplierProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => SupplierDueServiceProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => SupplierStatementProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => PostBusinessSupplierServiceProvider(),
        ),

        //Agent
        ChangeNotifierProvider(
          create: (context) => AddAgentProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => AgentDueServiceProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => AgentStatementProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => PostBusinessAgentProvider(),
        ),

        //For CashInCashOut
        ChangeNotifierProvider(
          create: (context) => CashInCashOutProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => CashBookReportServiceProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => EditCashInOutProvider(),
        ),
      ],
      child: const MainPage(),
    );
  }
}
