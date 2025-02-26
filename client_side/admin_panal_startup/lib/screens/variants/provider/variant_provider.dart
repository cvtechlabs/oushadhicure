import 'package:admin/models/variant_type.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:admin/core/data/data_provider.dart';
import 'package:admin/models/api_response.dart';
import 'package:admin/models/variant.dart';
import 'package:admin/services/http_services.dart';
import 'package:admin/utility/snack_bar_helper.dart';

class VariantsProvider extends ChangeNotifier {
  HttpService service = HttpService();
  final DataProvider _dataProvider;
  final addVariantsFormKey = GlobalKey<FormState>();
  TextEditingController variantCtrl = TextEditingController();
  VariantType? selectedVariantType;
  Variant? variantForUpdate;


  VariantsProvider(this._dataProvider);


  addVariant() async{
    try{
      Map<String, dynamic> variant = {
        'name' : variantCtrl.text, 'variantTypeId' : selectedVariantType?.sId};

      final response = await service.addItem(endpointUrl: 'variants', itemData: variant) ;
      if (response.isOk) {
        ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
        if (apiResponse.success == true) {
          clearFields();
          SnackBarHelper.showSuccessSnackBar('${apiResponse.message}');
          _dataProvider.getAllVariant();
          //log('Variant added');
        } else {
          SnackBarHelper.showErrorSnackBar('Failed to add Variant : ${apiResponse.message}' );
        }
      } else {
        SnackBarHelper.showErrorSnackBar('Error ${response.body?['message'] ?? response.statusText}' );
      }
    } catch (e) {
      print (e);
      SnackBarHelper.showErrorSnackBar('An error occurred : $e');
      rethrow;
    }
  }


  updateVariant() async {
    if (variantForUpdate != null) {
      try {
        Map<String, dynamic> variant = {
          'name': variantCtrl.text,
          'variantTypeId': selectedVariantType?.sId
        };

        final response =
        await service.updateItem(endpointUrl: 'variants',
            itemData: variant,
            itemId: variantForUpdate?.sId ?? '');
        if (response.isOk) {
          ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
          if (apiResponse.success == true) {
            clearFields();
            SnackBarHelper.showSuccessSnackBar('${apiResponse.message}');
            _dataProvider.getAllVariant();
            //log('Variant updated');
          } else {
            SnackBarHelper.showErrorSnackBar(
                'Failed to add Variant : ${apiResponse.message}');
          }
        } else {
          SnackBarHelper.showErrorSnackBar(
              'Error ${response.body?['message'] ?? response.statusText}');
        }
      } catch (e) {
        print(e);
        SnackBarHelper.showErrorSnackBar('An error occurred : $e');
        rethrow;
      }
    }
  }

  submitVariant(){
    if (variantForUpdate != null) {
      updateVariant();
    } else {
      addVariant();
    }
  }


  deleteVariant(Variant variant) async {
    try {
      Response response = await service.deleteItem(endpointUrl: 'variants',  itemId: variant.sId ?? '');
      if (response.isOk) {
        ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
        if (apiResponse.success == true) {
          SnackBarHelper.showSuccessSnackBar('Variant deleted successfully !');
          _dataProvider.getAllVariant();
        }
      } else {
        SnackBarHelper.showErrorSnackBar('Error ${response.body?['message'] ?? response.statusText}' );
      }
    }catch (e) {
      print (e);
      rethrow;
    }
  }


  setDataForUpdateVariant(Variant? variant) {
    if (variant != null) {
      variantForUpdate = variant;
      variantCtrl.text = variant.name ?? '';
      selectedVariantType =
          _dataProvider.variantTypes.firstWhereOrNull((element) => element.sId == variant.variantTypeId?.sId);
    } else {
      clearFields();
    }
  }

  clearFields() {
    variantCtrl.clear();
    selectedVariantType = null;
    variantForUpdate = null;
  }

  void updateUI() {
    notifyListeners();
  }
}
