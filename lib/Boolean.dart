import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BooleanInput Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool value = false;
  String selectType = 'checkbox';

  final Map<String, String> selectTypeNames = {
    'checkbox': 'Checkbox',
    'toggleButton': 'Toggle Button',
    'onOffButton': 'On/Off Button',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BooleanInput Example')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton<String>(
              value: selectType,
              items: selectTypeNames.keys.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(selectTypeNames[type]!),
                );
              }).toList(),
              onChanged: (newType) {
                if (newType != null) {
                  setState(() => selectType = newType);
                }
              },
            ),
            const SizedBox(height: 20),
            BooleanInput(
              value: value,
              selectType: selectType,
              onChanged: (val) => setState(() => value = val),
              checkboxActiveText: 'I Agree',
              checkboxInactiveText: 'I Disagree',
              toggleActiveText: 'Enabled',
              toggleInactiveText: 'Disabled',
              onOffActiveText: 'Power ON',
              onOffInactiveText: 'Power OFF',
            ),
          ],
        ),
      ),
    );
  }
}

class BooleanInput extends StatelessWidget {
  final bool value;
  final String selectType;
  final ValueChanged<bool> onChanged;

  final String checkboxActiveText;
  final String checkboxInactiveText;

  final String toggleActiveText;
  final String toggleInactiveText;

  final String onOffActiveText;
  final String onOffInactiveText;

  const BooleanInput({
    super.key,
    required this.value,
    required this.selectType,
    required this.onChanged,
    required this.checkboxActiveText,
    required this.checkboxInactiveText,
    required this.toggleActiveText,
    required this.toggleInactiveText,
    required this.onOffActiveText,
    required this.onOffInactiveText,
  });

  @override
  Widget build(BuildContext context) {
    Widget inputWidget;

    switch (selectType) {
      case 'checkbox':
        inputWidget = Row(
          children: [
            Checkbox(
              value: value,
              onChanged: (val) => onChanged(val ?? false),
            ),
            Text(value ? checkboxActiveText : checkboxInactiveText),
          ],
        );
        break;

      case 'toggleButton':
        inputWidget = GestureDetector(
          onTap: () => onChanged(!value),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value ? toggleActiveText : toggleInactiveText),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 60,
                height: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: value ? Colors.green : Colors.grey.shade400,
                ),
                child: Stack(
                  children: [
                    AnimatedAlign(
                      duration: const Duration(milliseconds: 300),
                      alignment:
                      value ? Alignment.centerRight : Alignment.centerLeft,
                      curve: Curves.easeInOut,
                      child: Container(
                        margin: const EdgeInsets.all(3),
                        width: 24,
                        height: 24,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
        break;

      case 'onOffButton':
        inputWidget = GestureDetector(
          onTap: () => onChanged(!value),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: value ? Colors.black : Colors.white,
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              value ? onOffActiveText : onOffInactiveText,
              style: TextStyle(
                color: value ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
        break;

      default:
        inputWidget = Text('Unknown selectType: $selectType');
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: inputWidget,
    );
  }
}
