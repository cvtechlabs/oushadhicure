import 'package:flutter/material.dart';
import '../utility/constants.dart';

class CustomDropdown<T> extends StatelessWidget {
  final T? initialValue;
  final List<T> items;
  final void Function(T?) onChanged;
  final String? Function(T?)? validator;
  final String hintText;
  final String Function(T) displayItem;

  const CustomDropdown({
    Key? key,
    this.initialValue,
    required this.items,
    required this.onChanged,
    this.validator,
    this.hintText = 'Select an option',
    required this.displayItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButtonFormField<T>(
        decoration: InputDecoration(
          labelText: hintText,
          labelStyle: TextStyle(color: fnColor),
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(bRadius),
          ),
        ),
        value: initialValue,
        items: items.map((T value) {
          return DropdownMenuItem<T>(
            value: value,
            child: Text(
              displayItem(value),
              style: TextStyle(color: fnColor), // Text color set to red
            ),
          );
        }).toList(),
        onChanged: onChanged,
        validator: validator,
      ),
    );
  }
}
