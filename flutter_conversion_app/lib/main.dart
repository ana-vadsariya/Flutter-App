import 'package:flutter/material.dart';

void main() {
  runApp(MeasureConverterApp());
}

class MeasureConverterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Measure Converter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.lightBlue[100], // Light blue background
          centerTitle: true, // Center the title
        ),
      ),
      home: MeasureConverterScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MeasureConverterScreen extends StatefulWidget {
  @override
  _MeasureConverterScreenState createState() => _MeasureConverterScreenState();
}

class _MeasureConverterScreenState extends State<MeasureConverterScreen> {
  final TextEditingController _controller = TextEditingController();
  String _fromUnit = 'meters';
  String _toUnit = 'feet';
  String _result = '';

  // Conversion rates relative to meters (for length) and kilograms (for weight)
  final Map<String, double> _baseRates = {
    'meters': 1.0,
    'feet': 3.28084,
    'kilometers': 1000.0,
    'miles': 1609.34,
    'kilograms': 1.0,
    'pounds': 0.453592,
  };

  final List<String> _lengthUnits = ['meters', 'feet', 'kilometers', 'miles'];
  final List<String> _weightUnits = ['kilograms', 'pounds'];
  List<String> _availableToUnits = [];

  @override
  void initState() {
    super.initState();
    _updateAvailableToUnits();
  }

  void _updateAvailableToUnits() {
    setState(() {
      if (_lengthUnits.contains(_fromUnit)) {
        _availableToUnits = List.from(_lengthUnits)..remove(_fromUnit);
      } else {
        _availableToUnits = List.from(_weightUnits)..remove(_fromUnit);
      }
      // Ensure toUnit is valid
      if (!_availableToUnits.contains(_toUnit)) {
        _toUnit = _availableToUnits.first;
      }
    });
  }

  void _convert() {
    double? input = double.tryParse(_controller.text);
    if (input == null) {
      setState(() {
        _result = 'Please enter a valid number';
      });
      return;
    }

    // Convert to base unit first (meters or kilograms)
    double inBase = input / _baseRates[_fromUnit]!;
    // Then convert to target unit
    double converted = inBase * _baseRates[_toUnit]!;

    setState(() {
      _result = '${input.toStringAsFixed(2)} $_fromUnit = ${converted.toStringAsFixed(4)} $_toUnit';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Measure Converter',
          style: TextStyle(
            color: Colors.blue[800], // Darker blue text for contrast
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Value', style: TextStyle(fontSize: 18)),
            TextField(
              controller: _controller,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                hintText: 'Enter value to convert',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            Text('From', style: TextStyle(fontSize: 18)),
            DropdownButton<String>(
              value: _fromUnit,
              isExpanded: true,
              items: [..._lengthUnits, ..._weightUnits].map((unit) {
                return DropdownMenuItem(
                  value: unit,
                  child: Text(unit),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _fromUnit = value!;
                  _updateAvailableToUnits();
                });
              },
            ),
            SizedBox(height: 16),
            Text('To', style: TextStyle(fontSize: 18)),
            DropdownButton<String>(
              value: _toUnit,
              isExpanded: true,
              items: _availableToUnits.map((unit) {
                return DropdownMenuItem(
                  value: unit,
                  child: Text(unit),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _toUnit = value!;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _convert,
              child: Text('Convert', style: TextStyle(fontSize: 18)),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _result,
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}