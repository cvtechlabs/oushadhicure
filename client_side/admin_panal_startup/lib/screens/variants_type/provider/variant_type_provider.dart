import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:admin/core/data/data_provider.dart';
import 'package:admin/models/api_response.dart';
import 'package:admin/models/variant_type.dart';
import 'package:admin/services/http_services.dart';
import 'package:admin/utility/snack_bar_helper.dart';

class VariantsTypeProvider extends ChangeNotifier {
  HttpService service = HttpService();
  final DataProvider _dataProvider;

  final addVariantsTypeFormKey = GlobalKey<FormState>();
  TextEditingController variantNameCtrl = TextEditingController();
  TextEditingController variantTypeCtrl = TextEditingController();

  VariantType? variantTypeForUpdate;

  VariantsTypeProvider(this._dataProvider);

  addVariantType() async{
    try{
      Map<String, dynamic> variantType = {'name' : variantNameCtrl.text, 'type' : variantTypeCtrl.text};

      final response = await service.addItem(endpointUrl: 'variantTypes', itemData: variantType) ;
      if (response.isOk) {
        ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
        if (apiResponse.success == true) {
          clearFields();
          SnackBarHelper.showSuccessSnackBar('${apiResponse.message}');
          _dataProvider.getAllVariantType();
          //log('variantType added');
        } else {
          SnackBarHelper.showErrorSnackBar('Failed to add Variant Type : ${apiResponse.message}' );
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

  updateVariantType() async {
    if (variantTypeForUpdate != null) {
      try {
        Map<String, dynamic> brand = {'name' : variantNameCtrl.text, 'type' : variantTypeCtrl.text};

        final response =
        await service.updateItem(endpointUrl: 'variantTypes',
            itemData: brand,
            itemId: variantTypeForUpdate?.sId ?? '');
        if (response.isOk) {
          ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
          if (apiResponse.success == true) {
            clearFields();
            SnackBarHelper.showSuccessSnackBar('${apiResponse.message}');
            _dataProvider.getAllVariantType();
            //log('variantType added');
          } else {
            SnackBarHelper.showErrorSnackBar(
                'Failed to modify Variant Type : ${apiResponse.message}');
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

  submitVariantType(){
    if (variantTypeForUpdate != null) {
      updateVariantType();
    } else {
      addVariantType();
    }
  }

  deleteVariantType(VariantType variantType) async {
    try {
      Response response = await service.deleteItem(endpointUrl: 'variantTypes',  itemId: variantType.sId ?? '');
      if (response.isOk) {
        ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
        if (apiResponse.success == true) {
          SnackBarHelper.showSuccessSnackBar('Variant Type deleted successfully !');
          _dataProvider.getAllVariantType();
        }
      } else {
        SnackBarHelper.showErrorSnackBar('Error ${response.body?['message'] ?? response.statusText}' );
      }
    }catch (e) {
      print (e);
      rethrow;
    }
  }

  setDataForUpdateVariantTYpe(VariantType? variantType) {
    if (variantType != null) {
      variantTypeForUpdate = variantType;
      variantNameCtrl.text = variantType.name ?? '';
      variantTypeCtrl.text = variantType.type ?? '';
    } else {
      clearFields();
    }
  }

  clearFields() {
    variantNameCtrl.clear();
    variantTypeCtrl.clear();
    variantTypeForUpdate = null;
  }
}
