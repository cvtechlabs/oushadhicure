import 'package:admin/models/sub_category.dart';
import '../provider/sub_category_provider.dart';
import 'package:admin/utility/extensions.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:admin/models/category.dart';
import 'package:admin/utility/constants.dart';
import 'package:admin/widgets/custom_dropdown.dart';
import 'package:admin/widgets/custom_text_field.dart';

class SubCategorySubmitForm extends StatelessWidget {
  final SubCategory? subCategory;

  const SubCategorySubmitForm({super.key, this.subCategory});

  @override
  Widget build(BuildContext context) {
    context.subCategoryProvider.setDataForUpdateSubCategory(subCategory);
    var size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Form(
        key: context.subCategoryProvider.addSubCategoryFormKey,
        child: Container(
          padding: EdgeInsets.all(defaultPadding),
          width: size.width * 0.5,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Gap(defaultPadding),
              Row(
                children: [
                  Expanded(
                    child: Consumer<SubCategoryProvider>(
                      builder: (context, subCatProvider, child) {
                        return CustomDropdown(
                          initialValue: subCatProvider.selectedCategory,
                          hintText: subCatProvider.selectedCategory?.name ?? 'Select category',
                          items: context.dataProvider.categories,
                          displayItem: (Category? category) => category?.name ?? '',
                          onChanged: (newValue) {
                            if (newValue != null) {
                              subCatProvider.selectedCategory = newValue;
                              subCatProvider.updateUi();
                            }
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Please select a category';
                            }
                            return null;
                          },
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: CustomTextField(
                      controller: context.subCategoryProvider.subCategoryNameCtrl,
                      labelText: 'Sub Category Name',
                      onSave: (val) {},
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a sub category name';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              Gap(defaultPadding * 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: fnColor,
                      backgroundColor: cbColor,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the popup
                    },
                    child: Text('Cancel'),
                  ),
                  Gap(defaultPadding),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: fnColor,
                      backgroundColor: sbColor,
                    ),
                    onPressed: () {
                      // Validate and save the form
                      if (context.subCategoryProvider.addSubCategoryFormKey.currentState!.validate()) {
                        context.subCategoryProvider.addSubCategoryFormKey.currentState!.save();
                        context.subCategoryProvider.submitSubCategory();
                        Navigator.of(context).pop();
                      }
                    },
                    child: Text('Submit'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// How to show the category popup
void showAddSubCategoryForm(BuildContext context, SubCategory? subCategory) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: bgColor,
        title: Center(child: Text('Add Sub Category'.toUpperCase(), style: TextStyle(color: primaryColor))),
        content: SubCategorySubmitForm(subCategory: subCategory),
      );
    },
  );
}
