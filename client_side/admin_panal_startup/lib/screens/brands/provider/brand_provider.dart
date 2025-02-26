import 'package:admin/models/brand.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:admin/core/data/data_provider.dart';
import 'package:admin/models/sub_category.dart';
import 'package:admin/services/http_services.dart';
import 'package:admin/models/api_response.dart';
import 'package:admin/utility/snack_bar_helper.dart';


class BrandProvider extends ChangeNotifier {
  HttpService service = HttpService();
  final DataProvider _dataProvider;

  final addBrandFormKey = GlobalKey<FormState>();
  TextEditingController brandNameCtrl = TextEditingController();
  SubCategory? selectedSubCategory;
  Brand? brandForUpdate;




  BrandProvider(this._dataProvider);

  addBrand() async{
    try{
      Map<String, dynamic> brand = {
        'name' : brandNameCtrl.text, 'subcategoryId' : selectedSubCategory?.sId};

      final response = await service.addItem(endpointUrl: 'brands', itemData: brand) ;
      if (response.isOk) {
        ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
        if (apiResponse.success == true) {
          clearFields();
          SnackBarHelper.showSuccessSnackBar('${apiResponse.message}');
          _dataProvider.getAllBrands();
          //log('Brand added');
        } else {
          SnackBarHelper.showErrorSnackBar('Failed to add Brand : ${apiResponse.message}' );
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


  updateBrand() async {
    if (brandForUpdate != null) {
      try {
        Map<String, dynamic> brand = {
          'name': brandNameCtrl.text,
          'subcategoryId': selectedSubCategory?.sId
        };

        final response =
        await service.updateItem(endpointUrl: 'brands',
            itemData: brand,
            itemId: brandForUpdate?.sId ?? '');
        if (response.isOk) {
          ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
          if (apiResponse.success == true) {
            clearFields();
            SnackBarHelper.showSuccessSnackBar('${apiResponse.message}');
            _dataProvider.getAllBrands();
            //log('category added');
          } else {
            SnackBarHelper.showErrorSnackBar(
                'Failed to add Brand : ${apiResponse.message}');
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

  submitBrand(){
    if (brandForUpdate != null) {
      updateBrand();
    } else {
      addBrand();
    }
  }


  deleteBrand(Brand brand) async {
    try {
      Response response = await service.deleteItem(endpointUrl: 'brands',  itemId: brand.sId ?? '');
      if (response.isOk) {
        ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
        if (apiResponse.success == true) {
          SnackBarHelper.showSuccessSnackBar('Sub Brand deleted successfully !');
          _dataProvider.getAllBrands();
        }
      } else {
        SnackBarHelper.showErrorSnackBar('Error ${response.body?['message'] ?? response.statusText}' );
      }
    }catch (e) {
      print (e);
      rethrow;
    }
  }



  //? set data for update on editing
  setDataForUpdateBrand(Brand? brand) {
    if (brand != null) {
      brandForUpdate = brand;
      brandNameCtrl.text = brand.name ?? '';
      selectedSubCategory = _dataProvider.subCategories.firstWhereOrNull((element) => element.sId == brand.subcategoryId?.sId);
    } else {
      clearFields();
    }
  }

  //? to clear text field and images after adding or update brand
  clearFields() {
    brandNameCtrl.clear();
    selectedSubCategory = null;
    brandForUpdate = null;
  }

  updateUI(){
    notifyListeners();
  }

}
