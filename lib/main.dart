// ignore_for_file: unused_field, unused_import

import 'package:flutter/material.dart';
import 'package:flutter_templates/SelectInput.dart';
import 'package:shimmer/shimmer.dart';
import 'NumberInput.dart';
import 'PasswoardInput.dart';
import 'SkeletonLoader.dart';
import 'TextInput.dart';
import 'Boolean.dart';



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TextInput Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
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

  List<String> _selectedCountries = [];

  String _dropdown = 'choose country';
  List<String> selectedCountry = [];
  List<String> selectedCountries = [];
  List<String> selectedValues = [];

  String _inputValue = '';
  String _name = '';
  String _passwoard = '';
  String _number = '';
  String _address = '';
  bool value = false;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('TextInput Example')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(height: 20),
              SkeletonLoader(
                itemCount: 1,
                baseSequence: [
                  'subtitle width:80 height:12',
                  'circle width:100 height:100',
                  'triangle width:20% height:40',
                  'title width:90 height:20',
                ],
                spacing: 20, // Controls all gaps
                isRow: true,
              ),


              TextInput(
                label: 'Enter Fruit Name',
                name: 'fruit',
                value: _inputValue,
                onChanged: (val) => setState(() => _inputValue = val),
                placeholder: 'e.g. Apple',
                required: true,
                unit: Unit(value: 'pcs', position: UnitPosition.end),
                icon: const Icon(Icons.search),
                enabled: false,
              ),

              SizedBox(height: 10),
              TextInput(
                label: 'Name',
                name: 'Name',
                placeholder: 'Enter your name',
                icon: const Icon(Icons.person),
                onChanged: (val) => setState(() => _name = val),
                value: '',
              ),

              SizedBox(height: 10),
              PasswordInput(
                label: 'Password',
                value: '',
                placeholder: 'Enter your password',
                icon: const Icon(Icons.lock),
                required: true,
                onChanged: (val) => setState(() => _passwoard = val),
              ),
              SizedBox(height: 20),
              SkeletonLoader(
                itemCount: 1,
                baseSequence: [
                  'subtitle width:80% height:12',
                  'title width:90% height:20',
                  'circle width:100 height:100',
                  'triangle width:20% height:40',
                ],
                spacing: 35,
                isRow: false,// Change this to control ALL gaps
              ),

              SizedBox(height: 10),
              NumberInput(
                label: 'Mobile Number',
                value: '',
                placeholder: 'Enter your mobile number',
                icon: const Icon(Icons.phone),
                required: true,
                maxLength: 10,
                onChanged: (val) => setState(() => _number = val),
              ),

              SizedBox(height: 10),
              TextInput(
                label: 'Home',
                name: 'Home',
                placeholder: 'Home Address',
                icon: const Icon(Icons.home),
                onChanged: (val) => setState(() => _address = val),
                value: '',
              ),

              SizedBox(height: 10),

              SelectInput(
               label: 'country',
               items: ['India', 'USA', 'UK'],
               selectType: 'multi',
               selectedValues: selectedCountry,
               onChanged: (vals) => setState(() => selectedCountry = vals), defaultValues: ['Select Country'],
            ),

              // const SizedBox(height: 20),
              // Text('Fruit: $_inputValue'),
              // const SizedBox(height: 20),
              // Text('Name: $_name'),
              // const SizedBox(height: 20),
              // Text('Passworad: $_passwoard'),
              // const SizedBox(height: 20),
              // Text('Mobile Number: $_number'),
              SizedBox(height: 20),

              SizedBox(height: 20),
              SkeletonLoader(
                itemCount: 1,
                baseSequence: [
                  'subtitle width:80% height:12',
                  'title width:90% height:20',
                  'circle width:100 height:100',
                  'triangle width:20% height:40',
                ],
                spacing: 50,
                isRow: false,// Change this to control ALL gaps
              ),
              SizedBox(height: 20),
              BooleanInput(
                value: value,
                selectType: 'checkbox', // 'toggleButton,onOffButton,checkbox
                onChanged: (val) => setState(() => value = val),
                checkboxInactiveText: 'No',
                checkboxActiveText: 'Yes',
                toggleInactiveText: 'Off',
                toggleActiveText: 'ON',
                onOffInactiveText: 'Power OFF',
                onOffActiveText: 'Power ON',
              ),

            ],
          ),
        ),
      ),
    );
  }
}

