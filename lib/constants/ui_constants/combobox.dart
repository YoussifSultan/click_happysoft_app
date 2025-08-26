import 'package:click_happysoft_app/constants/common_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class CustomComboboxitem {
  final String title;
  final int id;

  CustomComboboxitem({
    required this.title,
    required this.id,
  });
}

class CustomCombobox extends StatefulWidget {
  final String label;
  final String helperText;
  final String suffixText;
  final String? text;
  final Function? validator;
  final String? errorText;
  final IconData? icon;
  final List<CustomComboboxitem> dataList;
  final Function onSelected;
  final TextInputAction? customTextInputAction;

  const CustomCombobox({
    super.key,
    required this.dataList,
    required this.label,
    required this.helperText,
    this.text = "",
    this.validator,
    this.errorText,
    this.icon,
    this.suffixText = "",
    required this.onSelected,
    this.customTextInputAction = TextInputAction.next,
  });

  @override
  State<CustomCombobox> createState() => _CustomComboboxState();
}

class _CustomComboboxState extends State<CustomCombobox> {
  late final TextEditingController _myController;
  @override
  void initState() {
    _myController = TextEditingController(text: widget.text);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  InputBorder _customBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: color, width: 1.5),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TypeAheadField<CustomComboboxitem>(
      suggestionsCallback: (search) => widget.dataList
          .where((menuItem) =>
              menuItem.title.toLowerCase().contains(search.toLowerCase()))
          .toList(),
      builder: (context, controller, focusNode) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.label,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              AppSpacing.v4,
              TextFormField(
                controller: _myController,
                focusNode: focusNode,
                textInputAction: widget.customTextInputAction,
                decoration: InputDecoration(
                  hintText: widget.helperText,
                  suffixText: widget.suffixText,
                  errorText: widget.errorText,
                  enabledBorder: _customBorder(AppColors.light),
                  focusedBorder: _customBorder(AppColors.primary),
                  errorBorder: _customBorder(Colors.red),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  suffixIcon: Icon(widget.icon ?? Icons.edit,
                      size: 16, color: Colors.grey.shade400),
                ),
                validator: (value) {
                  if (widget.validator != null) {
                    return widget.validator!(value);
                  }
                  return null;
                },
              ),
            ],
          ),
        );
      },
      itemBuilder: (context, object) {
        return ListTile(
          title: Text(object.title),
          trailing: Text('${object.id}'),
        );
      },
      showOnFocus: true,
      controller: _myController,
      onSelected: (val) {
        _myController.text = val.title;
        widget.onSelected(val);
      },
    );
  }
}
