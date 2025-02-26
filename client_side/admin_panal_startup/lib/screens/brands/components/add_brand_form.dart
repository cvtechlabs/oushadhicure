import 'package:admin/models/sub_category.dart';
import '../provider/brand_provider.dart';
import 'package:admin/utility/extensions.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:admin/models/brand.dart';
import 'package:admin/utility/constants.dart';
import 'package:admin/widgets/custom_dropdown.dart';
import 'package:admin/widgets/custom_text_field.dart';

class BrandSubmitForm extends StatelessWidget {
  final Brand? brand;

  const BrandSubmitForm({super.key, this.brand});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    context.brandProvider.setDataForUpdateBrand(brand);
    return SingleChildScrollView(
      child: Form(
        key: context.brandProvider.addBrandFormKey,
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
                    child: Consumer<BrandProvider>(
                      builder: (context, brandProvider, child) {
                        return CustomDropdown(
                          initialValue: brandProvider.selectedSubCategory,
                          items: context.dataProvider.subCategories,
                          hintText: brandProvider.selectedSubCategory?.name ?? 'Select Sub Category',
                          displayItem: (SubCategory? subCategory) => subCategory?.name ?? '',
                          onChanged: (newValue) {
                            brandProvider.selectedSubCategory = newValue;
                            brandProvider.updateUI();
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Please select a Sub Category';
                            }
                            return null;
                          },
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: CustomTextField(
                      controller: context.brandProvider.brandNameCtrl,
                      labelText: 'Brand Name',
                      onSave: (val) {},
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a brand name';
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
                  SizedBox(width: defaultPadding),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: fnColor,
                      backgroundColor: sbColor,
                    ),
                    onPressed: () {
                      // Validate and save the form
                      if (context.brandProvider.addBrandFormKey.currentState!.validate()) {
                        context.brandProvider.addBrandFormKey.currentState!.save();
                        context.brandProvider.submitBrand();
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
void showBrandForm(BuildContext context, Brand? brand) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: bgColor,
        title: Center(child: Text('Add Brand'.toUpperCase(), style: TextStyle(color: primaryColor))),
        content: BrandSubmitForm(
          brand: brand,
        ),
      );
    },
  );
}
