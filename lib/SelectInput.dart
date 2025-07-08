import 'package:flutter/material.dart';

class SelectInput extends StatefulWidget {
  final String label;
  final List<String> items;
  final String selectType; // 'single' or 'multi'
  final List<String> selectedValues;
  final List<String> defaultValues;
  final ValueChanged<List<String>> onChanged;

  const SelectInput({
    Key? key,
    required this.label,
    required this.items,
    required this.selectType,
    required this.selectedValues,
    required this.onChanged,
    required this.defaultValues,
  }) : super(key: key);

  @override
  State<SelectInput> createState() => _SelectInputState();
}

class _SelectInputState extends State<SelectInput> {
  bool _isExpanded = false;
  String? _hoveredItem;

  void _handleSelection(String item) {
    final current = List<String>.from(widget.selectedValues);
    final isSelected = current.contains(item);

    if (widget.selectType == 'multi') {
      if (isSelected) {
        current.remove(item);
      } else {
        current.add(item);
      }
    } else {
      current.clear();
      current.add(item);
      // Do not close dropdown for single-select (as requested)
    }

    widget.onChanged(current);
  }

  void _removeSelectedItem(String item) {
    final current = List<String>.from(widget.selectedValues);
    current.remove(item);
    widget.onChanged(current);
  }

  @override
  Widget build(BuildContext context) {
    final hasSelection = widget.selectedValues.isNotEmpty;

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
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Theme.of(context).dividerColor),
              color: Colors.white,
            ),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            width: double.infinity,
            child: widget.selectType == 'multi'
                ? Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: hasSelection
                        ? widget.selectedValues.map((val) {
                            final isDefault = widget.defaultValues.contains(val);
                            return Chip(
                              label: Text(val),
                              deleteIcon: isDefault ? null : const Icon(Icons.close, size: 18),
                              onDeleted: isDefault ? null : () => _removeSelectedItem(val),
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              backgroundColor: Colors.grey.shade200,
                            );
                          }).toList()
                        : [
                            Text(
                              'Select ${widget.label}',
                              style: TextStyle(color: Colors.grey.shade600),
                            )
                          ],
                  )
                : Text(
                    hasSelection ? widget.selectedValues.first : 'Select ${widget.label}',
                    style: TextStyle(
                      color: hasSelection ? Colors.black : Colors.grey.shade600,
                    ),
                  ),
          ),
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          width: double.infinity,
          child: _isExpanded
              ? Container(
                  margin: const EdgeInsets.only(top: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).dividerColor),
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: widget.items.length,
                    itemBuilder: (context, index) {
                      final item = widget.items[index];
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
                            borderRadius: index == 0
                                ? const BorderRadius.vertical(top: Radius.circular(12))
                                : index == widget.items.length - 1
                                    ? const BorderRadius.vertical(bottom: Radius.circular(12))
                                    : BorderRadius.zero,
                          ),
                          child: ListTile(
                            title: Text(
                              item,
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.black,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                            trailing: isSelected
                                ? const Icon(Icons.check, color: Colors.white)
                                : null,
                            onTap: () => setState(() => _handleSelection(item)),
                          ),
                        ),
                      );
                    },
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}
