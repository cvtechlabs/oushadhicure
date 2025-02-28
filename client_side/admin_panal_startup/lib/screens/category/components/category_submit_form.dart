import 'package:admin/models/category.dart';
import '../provider/category_provider.dart';
import 'package:admin/utility/extensions.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:admin/utility/constants.dart';
import 'package:admin/widgets/category_image_card.dart';
import 'package:admin/widgets/custom_text_field.dart';
import 'package:admin/core/data/data_provider.dart';

class CategorySubmitForm extends StatefulWidget {
  final Category? category;

  const CategorySubmitForm({super.key, this.category});

  @override
  State<CategorySubmitForm> createState() => _CategorySubmitFormState();
}

class _CategorySubmitFormState extends State<CategorySubmitForm> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.categoryProvider.setDataForUpdateCategory(widget.category);
    _searchController.addListener(_onSearchChanged);
    if (widget.category != null && widget.category!.name != null) {
      _searchController.text = widget.category!.name!;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    context.categoryProvider.filterCategories(
        _searchController.text, context.read<DataProvider>().categories);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Form(
        key: context.categoryProvider.addCategoryFormKey,
        child: Container(
          padding: EdgeInsets.all(defaultPadding),
          width: size.width * 0.3,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(bRadius),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Gap(defaultPadding),
              Consumer<CategoryProvider>(
                builder: (context, catProvider, child) {
                  return CategoryImageCard(
                    labelText: "Category",
                    imageFile: catProvider.selectedImage,
                    imageUrlForUpdateImage: widget.category?.image,
                    onTap: () {
                      catProvider.pickImage();
                    },
                  );
                },
              ),
              Gap(defaultPadding),
              CustomTextField(
                controller: _searchController,
                labelText: 'Category Name',
                onSave: (val) {
                  context.categoryProvider.categoryNameCtrl.text = val ?? '';
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a category name';
                  }
                  return null;
                },
              ),
              Gap(defaultPadding),
              Consumer<CategoryProvider>(
                builder: (context, catProvider, child) {
                  if (_searchController.text.isNotEmpty && catProvider.filteredCategories.isNotEmpty) { // Modified condition
                    return Table(
                      columnWidths: const <int, TableColumnWidth>{
                        0: FlexColumnWidth(),
                      },
                      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                      children: catProvider.filteredCategories
                          .asMap()
                          .entries
                          .map((entry) {
                        final index = entry.key;
                        final category = entry.value;
                        return TableRow(
                          decoration: BoxDecoration(
                            color: index.isEven
                                ? Colors.transparent
                                : Colors.grey.withOpacity(0.1),
                          ),
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                category.name ?? '',
                                style: TextStyle(color: fnColor),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    );
                  } else {
                    return SizedBox.shrink();
                  }
                },
              ),
              Gap(defaultPadding * 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: cbFnColor,
                      backgroundColor: cbColor,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancel'),
                  ),
                  Gap(defaultPadding),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: sbFnColor,
                      backgroundColor: sbColor,
                    ),
                    onPressed: () {
                      if (context.categoryProvider.addCategoryFormKey.currentState!
                          .validate()) {
                        context.categoryProvider.addCategoryFormKey.currentState!
                            .save();
                        context.categoryProvider.submitCategory();
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

void showAddCategoryForm(BuildContext context, Category? category) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: bgColor,
        title: Center(
            child: Text('Add Category'.toUpperCase(),
                style: TextStyle(color: h1Color))),
        content: CategorySubmitForm(category: category),
      );
    },
  );
}

