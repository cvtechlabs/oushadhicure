import 'package:admin/core/data/data_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:admin/utility/constants.dart';
import 'package:admin/models/category.dart';
import 'add_category_form.dart';
import '../provider/category_provider.dart';

class CategoryListSection extends StatefulWidget {
  const CategoryListSection({Key? key}) : super(key: key);

  @override
  State<CategoryListSection> createState() => _CategoryListSectionState();
}

class _CategoryListSectionState extends State<CategoryListSection> {
  // Tracks the index of the column currently being sorted. Initially, no column is sorted.
  int _sortColumnIndex = 0;
  // Tracks the sorting order (ascending or descending). Initially, it's ascending.
  bool _sortAscending = true;
  // Stores the current search query entered by the user.
  String _searchQuery = '';
  // Controller for the search input field to manage and retrieve text.
  TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    // Dispose the search controller to free up resources and prevent memory leaks.
    _searchController.dispose();
    super.dispose();
  }

  // Function to sort the category list based on a given field (e.g., name, date).
  // Uses a generic type 'T' to allow sorting based on different data types.
  void _sort<T>(Comparable<T> Function(Category category) getField,
      int columnIndex, bool ascending) {
    // Read the DataProvider from the context to access category data and sorting functionality.
    context.read<DataProvider>().sortCategories((a, b) {
      // If sorting in descending order, swap 'a' and 'b' to reverse the comparison.
      if (!ascending) {
        final Category c = a;
        a = b;
        b = c;
      }
      // Get the value of the field to be sorted for each category.
      final Comparable<T> aValue = getField(a);
      final Comparable<T> bValue = getField(b);
      // Compare the values and return the sorting result.
      return aValue.compareTo(bValue as T);
    });
    // Update the state to reflect the new sorting order and column.
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get the screen width to dynamically adjust the table width.
    final screenWidth = MediaQuery.of(context).size.width;
    // Calculate the table width by subtracting padding from both sides of the screen.
    final tableWidth = screenWidth - (2 * defaultPadding);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(0)),
      ),
      child: Column(
        children: [
          // Search Bar Section: Allows users to filter categories by name.
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: defaultPadding, bottom: defaultPadding),
                  child: SizedBox(
                    height: 40,
                    child: TextField(
                      controller: _searchController,
                      style: TextStyle(color: fnColor),
                      decoration: InputDecoration(
                        hintText: 'Search categories...',
                        hintStyle: TextStyle(color: fnColor.withOpacity(0.5)),
                        prefixIcon: Icon(Icons.search, color: fnColor),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(bRadius),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(bRadius),
                          borderSide:
                              BorderSide(color: fnColor.withOpacity(0.3)),
                        ),
                      ),
                      onChanged: (value) {
                        // Update the search query and filter the categories when the text changes.
                        setState(() {
                          _searchQuery = value;
                          context.read<DataProvider>().filterCategories(value);
                        });
                      },
                    ),
                  ),
                ),
              ),
              Spacer(flex: 2), // Adjust spacing between search bar and buttons.
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Refresh Button: Reloads the category list from the data provider.
                  IconButton(
                    onPressed: () {
                      // Call the DataProvider method to fetch all categories and display a snackbar.
                      context
                          .read<DataProvider>()
                          .getAllCategory(showSnack: true);
                    },
                    icon: Icon(
                      Icons.refresh,
                      color: fnColor,
                    ),
                  ),
                  // Add New Button: Opens a form to add a new category.
                  ElevatedButton.icon(
                    style: TextButton.styleFrom(
                      backgroundColor: sbColor,
                      padding: EdgeInsets.symmetric(
                        horizontal: defaultPadding / .6,
                        vertical: defaultPadding / .8,
                      ),
                    ),
                    onPressed: () {
                      // Call the function to show the add category form.
                      showAddCategoryForm(context, null);
                    },
                    icon: Icon(
                      Icons.add,
                      color: fnColor,
                    ),
                    label: Text(
                      "Add New",
                      style: TextStyle(color: fnColor),
                    ),
                  ),
                ],
              ),
            ],
          ),
          // Table Section: Displays the category list in a scrollable table.
          Expanded(
            child: Column(
              children: [
                // Fixed Header Section: Displays column headers and sorting controls.
                Container(
                  width: tableWidth,
                  color: hdColor,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: InkWell(
                          // Sort by category name when the header is tapped.
                          onTap: () => _sort<String>(
                              (Category c) => c.name ?? '', 0, !_sortAscending),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                Text(
                                  'Category Name',
                                  style: TextStyle(
                                      color: tlColor,
                                      fontWeight: FontWeight.bold),
                                ),
                                // Display sorting icon if this column is sorted.
                                _sortColumnIndex == 0
                                    ? Icon(
                                        _sortAscending
                                            ? Icons.arrow_drop_up
                                            : Icons.arrow_drop_down,
                                        color: tlColor,
                                      )
                                    : SizedBox.shrink(),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: InkWell(
                          // Sort by added date when the header is tapped.
                          onTap: () => _sort<String>(
                              (Category c) => c.createdAt ?? '',
                              1,
                              !_sortAscending),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                Text(
                                  'Added Date',
                                  style: TextStyle(
                                      color: tlColor,
                                      fontWeight: FontWeight.bold),
                                ),
                                // Display sorting icon if this column is sorted.
                                _sortColumnIndex == 1
                                    ? Icon(
                                        _sortAscending
                                            ? Icons.arrow_drop_up
                                            : Icons.arrow_drop_down,
                                        color: tlColor,
                                      )
                                    : SizedBox.shrink(),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            'Actions',
                            style: TextStyle(
                                color: tlColor, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Scrollable Body Section: Displays the category data in table rows.
                Expanded(
                  child: SingleChildScrollView(
                    child: Consumer<DataProvider>(
                      builder: (context, dataProvider, child) {
                        return SizedBox(
                          width: tableWidth,
                          child: Table(
                            columnWidths: {
                              0: FlexColumnWidth(4),
                              1: FlexColumnWidth(3),
                              2: FlexColumnWidth(2),
                            },
                            children: List.generate(
                              dataProvider.categories.length,
                              (index) => TableRow(
                                decoration: BoxDecoration(
                                  color: index.isEven
                                      ? Colors.transparent
                                      : Colors.grey.withOpacity(0.1),
                                ),
                                children: [
                                  // Build and display the category name cell with inline editing.
                                  _buildNameCell(
                                      dataProvider.categories[index]),
                                  // Build and display the category added date cell.
                                  _buildDateCell(
                                      dataProvider.categories[index]),
                                  // Build and display the category actions cell (edit, delete).
                                  _buildActionsCell(
                                      dataProvider.categories[index]),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget to build the category name cell with inline editing functionality.
  Widget _buildNameCell(Category catInfo) {
    final TextEditingController nameController = TextEditingController(text: catInfo.name);
    bool isEditing = false;

    return StatefulBuilder(
      builder: (context, setState) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Image.network(
                catInfo.image ?? '',
                height: 30,
                width: 30,
                errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                  return Icon(Icons.error);
                },
              ),
              SizedBox(width: defaultPadding),
              if (isEditing)
                Expanded(
                  child: TextField(
                    controller: nameController,
                    style: TextStyle(color: fnColor),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    ),
                    onSubmitted: (value) {
                      setState(() {
                        isEditing = false;
                        if (value.trim().isNotEmpty && value != catInfo.name && catInfo.name != null) {
                          if (catInfo.sId != null) {
                            context.read<CategoryProvider>().updateCategoryName(catInfo.sId, value, catInfo.image); // Pass image
                          } else {
                            print("Error: catInfo.sId is null!");
                          }
                        }
                      });
                    },
                  ),
                )
              else
                Expanded(
                  child: Text(
                    catInfo.name ?? '',
                    style: TextStyle(color: fnColor),
                  ),
                ),
              IconButton(
                icon: Icon(
                  isEditing ? Icons.check : Icons.edit,
                  color: sbColor,
                ),
                onPressed: () {
                  setState(() {
                    if (isEditing) {
                      if (nameController.text.trim().isNotEmpty && nameController.text != catInfo.name && catInfo.name != null) {
                        if (catInfo.sId != null) {
                          context.read<CategoryProvider>().updateCategoryName(catInfo.sId, nameController.text, catInfo.image); // Pass image
                        } else {
                          print("Error: catInfo.sId is null!");
                        }
                      }
                      isEditing = false;
                    } else {
                      isEditing = true;
                    }
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }


  // Widget to build the category added date cell.
  Widget _buildDateCell(Category catInfo) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        catInfo.createdAt ?? '',
        style: TextStyle(color: fnColor),
      ),
    );
  }

  // Widget to build the category actions cell (edit and delete buttons).
  Widget _buildActionsCell(Category catInfo) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Edit button: Opens the add/edit category form for editing.
          IconButton(
            icon: Icon(Icons.edit, color: sbColor),
            onPressed: () => showAddCategoryForm(context, catInfo),
          ),
          // Delete button: Deletes the category from the data provider.
          IconButton(
            icon: Icon(Icons.delete, color: cbColor),
            onPressed: () =>
                context.read<CategoryProvider>().deleteCategory(catInfo),
          ),
        ],
      ),
    );
  }
}
