import 'package:admin/models/order.dart';
import 'package:admin/services/http_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:admin/core/data/data_provider.dart';


class OrderProvider extends ChangeNotifier {
  HttpService service = HttpService();
  final DataProvider _dataProvider;
  final orderFormKey = GlobalKey<FormState>();
  TextEditingController trackingUrlCtrl = TextEditingController();
  String selectedOrderStatus = 'pending';
  Order? orderForUpdate;

  OrderProvider(this._dataProvider);

  //TODO: should complete updateOrder


  //TODO: should complete deleteOrder


  updateUI() {
    notifyListeners();
  }
}
