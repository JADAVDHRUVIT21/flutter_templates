import 'package:flutter/material.dart';

class SelectInput extends StatefulWidget {
  final String label;
  final List<String> selectedValues;
  final List<String> items;
  final ValueChanged<List<String>> onChanged;

  const SelectInput({
    Key? key,
    required this.label,
    required this.selectedValues,
    required this.items,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<SelectInput> createState() => _SelectInputState();
}

class _SelectInputState extends State<SelectInput> {
  bool _isExpanded = false;
  String? _hoveredItem;

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Theme.of(context).dividerColor),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
            child: Text(
              widget.label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
            ),
          ),
        GestureDetector(
          onTap: () => setState(() => _isExpanded = !_isExpanded),
          child: InputDecorator(
            decoration: InputDecoration(
              border: border,
              enabledBorder: border,
              filled: true,
              fillColor: Colors.white,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            ),
            child: Wrap(
              spacing: 6.0,
              runSpacing: 6.0,
              children: widget.selectedValues.isEmpty
                  ? [
                      Text('Select countries',
                          style: TextStyle(color: Colors.grey.shade600))
                    ]
                  : widget.selectedValues
                      .map((val) => Chip(
                            label: Text(val),
                            onDeleted: () {
                              final updated =
                                  List<String>.from(widget.selectedValues)
                                    ..remove(val);
                              widget.onChanged(updated);
                            },
                          ))
                      .toList(),
            ),
          ),
        ),
        if (_isExpanded)
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).dividerColor),
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
            ),
            child: Column(
              children: List.generate(widget.items.length, (index) {
                final item = widget.items[index];
                final isFirst = index == 0;
                final isLast = index == widget.items.length - 1;
                final isSelected = widget.selectedValues.contains(item);
                final isHovered = _hoveredItem == item;

                return MouseRegion(
                  onEnter: (_) => setState(() => _hoveredItem = item),
                  onExit: (_) => setState(() => _hoveredItem = null),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.black
                          : isHovered
                              ? Colors.grey.shade300
                              : Colors.transparent,
                      borderRadius: BorderRadius.vertical(
                        top:
                            isFirst ? const Radius.circular(12) : Radius.zero,
                        bottom:
                            isLast ? const Radius.circular(12) : Radius.zero,
                      ),
                      border: isHovered
                          ? Border.all(color: Colors.grey.shade600, width: 1)
                          : null,
                    ),
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top:
                              isFirst ? const Radius.circular(12) : Radius.zero,
                          bottom:
                              isLast ? const Radius.circular(12) : Radius.zero,
                        ),
                      ),
                      title: Text(
                        item,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontWeight: isHovered || isSelected
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                      trailing: isSelected
                          ? const Icon(Icons.check, color: Colors.white)
                          : null,
                      onTap: () {
                        final updated =
                            List<String>.from(widget.selectedValues);
                        if (isSelected) {
                          updated.remove(item);
                        } else {
                          updated.add(item);
                        }
                        widget.onChanged(updated);
                      },
                    ),
                  ),
                );
              }),
            ),
          ),
      ],
    );
  }
}
