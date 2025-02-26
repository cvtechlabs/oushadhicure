import 'package:admin/models/notification_result.dart';
import 'package:flutter/cupertino.dart';
import 'package:admin/core/data/data_provider.dart';
import 'package:admin/services/http_services.dart';


class NotificationProvider extends ChangeNotifier {
  HttpService service = HttpService();
  final DataProvider _dataProvider;

  final sendNotificationFormKey = GlobalKey<FormState>();

  TextEditingController titleCtrl = TextEditingController();
  TextEditingController descriptionCtrl = TextEditingController();
  TextEditingController imageUrlCtrl = TextEditingController();

  NotificationResult? notificationResult;

  NotificationProvider(this._dataProvider);


  //TODO: should complete sendNotification


  //TODO: should complete deleteNotification

  //TODO: should complete getNotificationInfo

  clearFields() {
    titleCtrl.clear();
    descriptionCtrl.clear();
    imageUrlCtrl.clear();
  }

  updateUI() {
    notifyListeners();
  }
}
