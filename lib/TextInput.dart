import 'package:flutter/material.dart';

class TextInput extends StatefulWidget {
  final String label;
  final String name;
  final String value;
  final ValueChanged<String> onChanged;
  final bool required;
  final String? placeholder;
  final Widget icon;
  final Unit? unit;
  final List<String>? suggestions;
  final bool enabled; // ✅ New parameter to enable/disable input

  const TextInput({
    Key? key,
    required this.label,
    required this.name,
    required this.value,
    required this.onChanged,
    this.required = false,
    this.placeholder,
    required this.icon,
    this.unit,
    this.suggestions,
    this.enabled = true, // ✅ default to true
  }) : super(key: key);

  @override
  State<TextInput> createState() => _TextInputState();
}

class Unit {
  final String value;
  final UnitPosition position;

  Unit({required this.value, required this.position});
}

enum UnitPosition { start, end }

class _TextInputState extends State<TextInput> {
  late final TextEditingController _controller = TextEditingController(text: widget.value);

  @override
  void didUpdateWidget(covariant TextInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value && _controller.text != widget.value) {
      _controller.text = widget.value;
    }
  }

  InputDecoration _buildDecoration() {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Theme.of(context).dividerColor),
    );
    return InputDecoration(
      prefixIcon: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: widget.icon,
      ),
      prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
      hintText: widget.placeholder,
      border: border,
      enabledBorder: border,
      focusedBorder: border.copyWith(
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.primary,
          width: 2,
        ),
      ),
      disabledBorder: border,
      filled: true,
      fillColor: widget.enabled ? Colors.white : Colors.grey.shade100, // ✅ lighter background for disabled
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      prefix: widget.unit?.position == UnitPosition.start
          ? Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Text(widget.unit!.value),
      )
          : null,
      suffix: widget.unit?.position == UnitPosition.end
          ? Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Text(widget.unit!.value),
      )
          : null,
    );
  }

  Widget _buildLabel() => widget.label.isEmpty
      ? const SizedBox.shrink()
      : Padding(
    padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
    child: RichText(
      text: TextSpan(
        text: widget.label,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
        children: widget.required
            ? [
          TextSpan(
              text: ' *',
              style:
              TextStyle(color: Theme.of(context).colorScheme.error))
        ]
            : [],
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(),
        widget.suggestions != null
            ? Autocomplete<String>(
          optionsBuilder: (input) => input.text.isEmpty
              ? const Iterable<String>.empty()
              : widget.suggestions!.where((s) =>
              s.toLowerCase().contains(input.text.toLowerCase())),
          fieldViewBuilder:
              (context, controller, focusNode, onFieldSubmitted) {
            controller.value = _controller.value;
            return TextField(
              controller: _controller,
              focusNode: focusNode,
              enabled: widget.enabled, // ✅ control enabled state
              onChanged: (val) {
                widget.onChanged(val);
                _controller.text = val;
                _controller.selection = TextSelection.fromPosition(
                  TextPosition(offset: _controller.text.length),
                );
              },
              decoration: _buildDecoration(),
            );
          },
          onSelected: (val) {
            widget.onChanged(val);
            _controller.text = val;
          },
        )
            : TextField(
          controller: _controller,
          onChanged: widget.onChanged,
          enabled: widget.enabled, // ✅ control enabled state
          decoration: _buildDecoration(),
        ),
      ],
    );
  }
}
