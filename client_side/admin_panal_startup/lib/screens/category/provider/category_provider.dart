import 'dart:io';
import 'package:admin/services/http_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:admin/core/data/data_provider.dart';
import 'package:admin/models/category.dart';
import 'package:admin/models/api_response.dart';
import 'package:admin/utility/snack_bar_helper.dart';

class CategoryProvider extends ChangeNotifier {
  HttpService service = HttpService();
  final DataProvider _dataProvider;
  final addCategoryFormKey = GlobalKey<FormState>();
  TextEditingController categoryNameCtrl = TextEditingController();
  Category? categoryForUpdate;

  File? selectedImage;
  XFile? imgXFile;

  List<Category> filteredCategories = [];

  CategoryProvider(this._dataProvider);

  addCategory() async {
    try {
      if (selectedImage == null) {
        SnackBarHelper.showErrorSnackBar('Please Choose An Image !');
        return;
      }
      if (categoryNameCtrl.text.isEmpty) {
        SnackBarHelper.showErrorSnackBar('Please Enter a Category Name !');
        return;
      }
      Map<String, dynamic> formDataMap = {
        'name': categoryNameCtrl.text,
        'image': 'no_data',
      };

      final FormData form = await createFormData(imgXFile: imgXFile, formData: formDataMap);

      final response = await service.addItem(endpointUrl: 'categories', itemData: form);
      if (response.isOk) {
        ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
        if (apiResponse.success == true) {
          clearFields();
          SnackBarHelper.showSuccessSnackBar('${apiResponse.message}');
          _dataProvider.getAllCategory();
        } else {
          SnackBarHelper.showErrorSnackBar('Failed to add Category : ${apiResponse.message}');
        }
      } else {
        SnackBarHelper.showErrorSnackBar('Error ${response.body?['message'] ?? response.statusText}');
      }
    } catch (e) {
      print(e);
      SnackBarHelper.showErrorSnackBar('An error occurred : $e');
      rethrow;
    }
  }

  updateCategory() async {
    try {
      Map<String, dynamic> formDataMap = {
        'name': categoryNameCtrl.text,
        'image': categoryForUpdate?.image ?? '',
      };

      final FormData form = await createFormData(imgXFile: imgXFile, formData: formDataMap);

      final response = await service.updateItem(endpointUrl: 'categories', itemData: form, itemId: categoryForUpdate?.sId ?? '');

      if (response.isOk) {
        ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
        if (apiResponse.success == true) {
          clearFields();
          SnackBarHelper.showSuccessSnackBar('${apiResponse.message}');
          _dataProvider.getAllCategory();
        } else {
          SnackBarHelper.showErrorSnackBar('Failed to add Category : ${apiResponse.message}');
        }
      } else {
        SnackBarHelper.showErrorSnackBar('Error ${response.body?['message'] ?? response.statusText}');
      }
    } catch (e) {
      print(e);
      SnackBarHelper.showErrorSnackBar('An error occurred : $e');
      rethrow;
    }
  }

  Future<void> updateCategoryName(String? sId, String newName, String? currentImage) async {
    if (sId == null) {
      print("Error: sId is null in updateCategoryName!");
      SnackBarHelper.showErrorSnackBar("Error: Category ID is missing.");
      return;
    }

    try {
      Map<String, dynamic> formDataMap = {
        'name': newName,
        'image': currentImage ?? '',
      };

      final FormData form = FormData(formDataMap);

      final response = await service.updateItem(
        endpointUrl: 'categories',
        itemData: form,
        itemId: sId!,
      );

      if (response.isOk) {
        ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
        if (apiResponse.success == true) {
          SnackBarHelper.showSuccessSnackBar('${apiResponse.message}');
          _dataProvider.getAllCategory();
        } else {
          SnackBarHelper.showErrorSnackBar('Failed to update Category Name: ${apiResponse.message}');
        }
      } else {
        SnackBarHelper.showErrorSnackBar('Error ${response.body?['message'] ?? response.statusText}');
      }
    } catch (e) {
      print(e);
      SnackBarHelper.showErrorSnackBar('An error occurred: $e');
      rethrow;
    }
  }

  submitCategory() {
    if (categoryForUpdate != null) {
      updateCategory();
    } else {
      addCategory();
    }
  }

  void pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImage = File(image.path);
      imgXFile = image;
      notifyListeners();
    }
  }

  deleteCategory(Category category) async {
    try {
      Response response = await service.deleteItem(endpointUrl: 'categories', itemId: category.sId ?? '');
      if (response.isOk) {
        ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
        if (apiResponse.success == true) {
          SnackBarHelper.showSuccessSnackBar('Category deleted successfully !');
          _dataProvider.getAllCategory();
        }
      } else {
        SnackBarHelper.showErrorSnackBar('Error ${response.body?['message'] ?? response.statusText}');
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<FormData> createFormData({required XFile? imgXFile, required Map<String, dynamic> formData}) async {
    if (imgXFile != null) {
      MultipartFile multipartFile;
      if (kIsWeb) {
        String fileName = imgXFile.name;
        Uint8List byteImg = await imgXFile.readAsBytes();
        multipartFile = MultipartFile(byteImg, filename: fileName);
      } else {
        String fileName = imgXFile.path.split('/').last;
        multipartFile = MultipartFile(imgXFile.path, filename: fileName);
      }
      formData['img'] = multipartFile;
    }
    final FormData form = FormData(formData);
    return form;
  }

  setDataForUpdateCategory(Category? category) {
    if (category != null) {
      clearFields();
      categoryForUpdate = category;
      categoryNameCtrl.text = category.name ?? '';
    } else {
      clearFields();
    }
  }

  clearFields() {
    categoryNameCtrl.clear();
    selectedImage = null;
    imgXFile = null;
    categoryForUpdate = null;
  }

  void filterCategories(String query, List<Category> allCategories) {
    if (query.isEmpty) {
      filteredCategories = [];
    } else {
      filteredCategories = allCategories
          .where((category) => (category.name ?? '').toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }
}