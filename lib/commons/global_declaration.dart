import 'package:shared_preferences/shared_preferences.dart';
import 'package:webshop/commons/exporter.dart';

SharedPreferences? sharedPref;
String? token;
bool addCustomerFromSales = false;
bool addStockFromPurchase = false;

String? printIp = sharedPref!.getString('printer_ip');

const website = "https://webbook.com.np/";
const phoneNumber = '014168260';
const youtube = 'https://www.youtube.com/@webbooksupport8470';
const email = 'webbookhelp@gmail.com';
const facebookHandle = 'webbooksoftware';

class Strings {
  static String ip = '/api/webshop';
  static String webShopUrl = (sharedPref!.getString('server_text')) == null ? 'http://182.93.85.199:8085/webshop' : 'http://182.93.85.199:8085/${sharedPref!.getString('server_text')}';
  static String webShopImage = '$webShopUrl/images';

  static String login = '$ip/login';
  static String validMAC = '$ip/ValidMAC';
  static String updateMAC = '$ip/UpdateMAC';
  static String tabletSetup = '$ip/GetTabletSetup';

  //Supplier
  static String createSupplier = '$ip/CreateSupplier';
  static String getSupplierDue = '$ip/GetSupplierDue';
  static String getSupplierStatement = '$ip/GetSupplierStatement';
  static String postBusinessSupplier = '$ip/PostBusiness';

  //Agent
  static String createAgent = '$ip/CreateAgent';
  static String getAgentDue = '$ip/GetAgentDue';
  static String getAgentStatement = '$ip/GetAgentStatement';
  static String postBusinessAgent = '$ip/PostBusiness';

  //Brand
  static String createBrand = '$ip/CreateBrand';

  //group
  static String createGroup = '$ip/UpdateItemGroup';
  static String getGroup = '$ip/GetAllItemGroup';

  //stock
  static String addStock = '$ip/CreateStock';
  static String deleteStock = '$ip/DeleteStock';
  static String getStockSummary = '$ip/GetStockSummary';
  static String getStockStatement = '$ip/GetStockStatement';
  static String getStockDetail = '$ip/GetStockDetail';
  static String getStockList = '$ip/GetStockList';
  //sale
  static String findSale = '$ip/FindSale';
  static String getSaleSummary = '$ip/GetSaleSummary';
  static String getSalesReport = '$ip/GetSalesReport';
  static String getSalesById = '$ip/GetSaleById';
  static String updateSales = '$ip/UpdateSales';
  static String deleteSales = '$ip/DeleteSales';

  //For Sale return
  static String searchSalesByBillNo = '$ip/SearchSaleByBillNo';

  //purchase
  static String findPurchaseSummary = '$ip/FindPurchase'; //for purchase purType==1 and for purchase return purtype ==2 must be implemented
  static String deletePurchase = '$ip/DeletePurchase';
  static String deletePurchaseItem = '$ip/DeletePurchaseItem';
  static String updatePurchase = '$ip/UpdatePurchase';
  static String getPurchaseById = '$ip/GetPurchaseById';
  static String getPurchaseByBillNo = '$ip/GetPurchaseByBillNo';

  //CashInCashOut
  static String cashInCashOut = '$ip/GetCashInCashOut';
  static String getCashBook = '$ip/GetCashBook';
  static String getBusinessById= '$ip/GetBusinessById';
}

//for headerSelection of credit pay page
List tranTypeList = [
  {
    "id": "1",
    "name": "Cash",
  },
  {
    "id": "2",
    "name": "Credit",
  },
  {
    "id": "3",
    "name": "POS Card",
  },
  {
    "id": "4",
    "name": "E PAY",
  },
];

List customerTypeTranList = [
  {
    "id": "1",
    "name": "Credit",
  },
  {
    "id": "2",
    "name": "POS Card",
  },
  {
    "id": "3",
    "name": "E PAY",
  },
];

List paymentType = [
  {
    "id": "0",
    "name": "Credit",
  },
  {
    "id": "1",
    "name": "Cash",
  },
];

List agentSource = [
  {
    "id": "1",
    "name": "COMPANY",
  },
  {
    "id": "2",
    "name": "PERSONAL",
  },
  {
    "id": "3",
    "name": "RELATIVE",
  },
  {
    "id": "4",
    "name": "REGULAR",
  },
  {
    "id": "5",
    "name": "CARD",
  },
];

List tranType = [
  {
    "id": "1",
    "name": "Purchase",
  },
  {
    "id": "2",
    "name": "Purchase Return",
  },
];

List tranMode = [
  {
    "id": "0",
    "name": "VAT",
  },
  {
    "id": "1",
    "name": "Non VAT",
  },
];
//For CashIn CashOut Cash Recieve and payment
List cicoBillCode = [
  {
    "id": "1",
    "name": "Cash Payment",
  },
  {
    "id": "2",
    "name": "Cash Recieved",
  },
  {
    "id": "3",
    "name": "Miscellanous",
  },
];
