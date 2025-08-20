import 'package:click_happysoft_app/ui_commonwidgets/common_constants.dart';
import 'package:click_happysoft_app/ui_commonwidgets/menu_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CustomTextBox extends StatefulWidget {
  final String label;
  final String? helperText;
  final Function? validator;
  final Function? onSaved;
  final String? errorText;
  final TextInputType? keyboardType;
  final IconData? icon;
  final bool? isMultiline;
  final bool? readonly;
  final bool? isPassword;
  final String? defaultText;
  final String? suffixText;
  final TextInputAction? customTextInputAction;

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
    this.isPassword = false,
    this.onSaved,
    this.suffixText = "",
    this.keyboardType = TextInputType.text,
    this.customTextInputAction = TextInputAction.next,
  });

  @override
  State<CustomTextBox> createState() => _CustomTextBoxState();
}

class _CustomTextBoxState extends State<CustomTextBox> {
  TextEditingController controller = TextEditingController();
  @override
  void initState() {
    controller.text = widget.defaultText!;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant CustomTextBox oldWidget) {
    if (oldWidget.defaultText != widget.defaultText) {
      controller.text = widget.defaultText!;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    controller.dispose();
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
            controller: controller,
            readOnly: widget.readonly!,
            maxLines: widget.isMultiline! ? 3 : 1,
            keyboardType: widget.keyboardType,
            textInputAction: widget.customTextInputAction,
            obscureText: widget.isPassword!,
            decoration: InputDecoration(
              hintText: widget.helperText,
              errorText: widget.errorText,
              suffixText: widget.suffixText,
              enabledBorder: _customBorder(AppColors.light),
              focusedBorder: _customBorder(AppColors.primary),
              errorBorder: _customBorder(Colors.red),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              suffixIcon: Icon(widget.icon ?? Icons.edit,
                  size: 16, color: Colors.grey.shade400),
            ),
            onSaved: (val) {
              if (widget.onSaved != null) {
                widget.onSaved!(val);
              }
            },
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
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(60),
                        border: Border.all(
                            width: 2,
                            color: isHover ? AppColors.white : color)),
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
  final String suffixText;
  final String? text;
  final Function? validator;
  final String? errorText;
  final IconData? icon;
  final List<MenuItemObject> dataList;
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
          .where((menuItem) =>
              menuItem.title.toLowerCase().contains(search.toLowerCase()))
          .toList(),
      builder: (context, controller, focusNode) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          controller.text = widget.text!;
        });
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
          title: Text(object.name),
          trailing: Text('${object.id ?? ''}'),
        );
      },
      showOnFocus: true,
      onSelected: (val) {
        widget.onSelected(val);
      },
    );
  }
}

class DatepickerBox extends StatefulWidget {
  final Function? onSaved;
  final String label;
  final DateTime initialDate;
  final DateTime lastDate;

  const DatepickerBox(
      {super.key,
      this.onSaved,
      this.label = "",
      required this.initialDate,
      required this.lastDate});

  @override
  State<DatepickerBox> createState() => _DatepickerBoxState();
}

class _DatepickerBoxState extends State<DatepickerBox> {
  final TextEditingController _dateController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: widget.initialDate,
      firstDate: DateTime(2000),
      lastDate: widget.lastDate,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.light, // calendar header
              onPrimary: AppColors.dark, // calendar text
              onSurface: AppColors.primary, // body text
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.black, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        _dateController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
      });
    }
  }

  @override
  void initState() {
    _dateController.text = DateFormat('dd/MM/yyyy').format(widget.initialDate);
    super.initState();
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
        child: TextFormField(
          controller: _dateController,
          readOnly: true,
          decoration: InputDecoration(
            labelText: widget.label,
            hintText: 'DD/MM/YYYY',
            enabledBorder: _customBorder(AppColors.light),
            focusedBorder: _customBorder(AppColors.primary),
            suffixIcon: IconButton(
              icon: const Icon(Icons.calendar_today),
              onPressed: () => _selectDate(context),
            ),
          ),
          onSaved: (val) {
            if (widget.onSaved != null) {
              widget.onSaved!(DateFormat('dd/MM/yyyy').parse(val!));
            }
          },
        ));
  }
}
