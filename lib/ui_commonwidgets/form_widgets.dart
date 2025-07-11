import 'package:click_happysoft_app/ui_commonwidgets/common_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';

class CustomTextBox extends StatefulWidget {
  final String label;
  final String? helperText;
  final Function? validator;
  final String? errorText;
  final IconData? icon;
  final bool? isMultiline;
  final bool? readonly;
  final String? defaultText;

  const CustomTextBox({
    super.key,
    required this.label,
    this.helperText = "",
    this.errorText,
    this.isMultiline = false,
    this.icon,
    this.readonly = false,
    this.validator,
    this.defaultText = "",
  });

  @override
  State<CustomTextBox> createState() => _CustomTextBoxState();
}

class _CustomTextBoxState extends State<CustomTextBox> {
  @override
  void initState() {
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.label,
              style: const TextStyle(fontWeight: FontWeight.bold)),
          AppSpacing.v4,
          TextFormField(
            initialValue: widget.defaultText,
            readOnly: widget.readonly!,
            maxLines: widget.isMultiline! ? 20 : 1,
            decoration: InputDecoration(
              hintText: widget.helperText,
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
  }
}

class CustomButton extends StatelessWidget {
  final String text;
  final Color color;
  final IconData icon;
  final VoidCallback onPressed;
  final RxBool _onHover = false.obs;

  CustomButton({
    super.key,
    required this.text,
    required this.color,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _onHover.value = true,
      onExit: (_) => _onHover.value = false,
      child: GestureDetector(
        onTapDown: (_) => _onHover.value = true,
        onTapUp: (_) {
          _onHover.value = false;
          onPressed();
        },
        onTapCancel: () => _onHover.value = false,
        child: Obx(() {
          final isHover = _onHover.value;

          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: isHover ? color : Colors.transparent,
              border: Border.all(color: color, width: 2),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  text,
                  style: TextStyle(
                    color: isHover ? Colors.white : color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                AppSpacing.h16,
                Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(60),
                        border: Border.all(
                            width: 2,
                            color:
                                isHover ? AppColors.white : AppColors.primary)),
                    child:
                        Icon(icon, color: isHover ? AppColors.white : color)),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class CustomCombobox extends StatefulWidget {
  final String label;
  final String helperText;
  final String? text;
  final Function? validator;
  final String? errorText;
  final IconData? icon;
  final List<dynamic> dataList;
  final Rx<dynamic> selectedData;

  const CustomCombobox({
    super.key,
    required this.dataList,
    required this.selectedData,
    required this.label,
    required this.helperText,
    this.text,
    this.validator,
    this.errorText,
    this.icon,
  });

  @override
  State<CustomCombobox> createState() => _CustomComboboxState();
}

class _CustomComboboxState extends State<CustomCombobox> {
  @override
  void initState() {
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
    return TypeAheadField<dynamic>(
      suggestionsCallback: (search) => widget.dataList
          .where((customer) =>
              customer.name.toLowerCase().contains(search.toLowerCase()))
          .toList(),
      builder: (context, controller, focusNode) {
        ever(widget.selectedData, (val) => controller.text = val.name);
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.label,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              AppSpacing.v4,
              TextFormField(
                controller: controller,
                focusNode: focusNode,
                decoration: InputDecoration(
                  hintText: widget.helperText,
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
      itemBuilder: (context, customer) {
        return ListTile(
          title: Text(customer.name),
          trailing: Text('${customer.id}'),
        );
      },
      showOnFocus: true,
      onSelected: (customer) {
        widget.selectedData.value = customer;
      },
    );
  }
}
