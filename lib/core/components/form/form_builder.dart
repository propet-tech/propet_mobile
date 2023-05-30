import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class FormBuilderDropdownSearch<T> extends StatelessWidget {
  final String name;

  const FormBuilderDropdownSearch({
    super.key,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return FormBuilderField<T>(
      name: name,
      builder: (field) {
        return DropdownSearch<T>(
          onChanged: (value) => field.didChange(value),
          selectedItem: field.value,
        );
      },
    );
  }
}
