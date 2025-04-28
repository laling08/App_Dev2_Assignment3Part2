import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const BMICalculatorApp());
}

class BMICalculatorApp extends StatelessWidget {
  const BMICalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BMI Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Colors.grey[100],
        fontFamily: 'Roboto',
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.teal, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      home: const InputPage(),
    );
  }
}

class InputPage extends StatefulWidget {
  const InputPage({super.key});

  @override
  State<InputPage> createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  String _selectedGender = 'Male';
  String _heightUnit = 'cm';
  String _weightUnit = 'kg';

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _calculateBMI() {
    if (_formKey.currentState!.validate()) {
      // Convert height to meters
      double heightValue = double.parse(_heightController.text);
      if (_heightUnit == 'inches') {
        heightValue = heightValue * 2.54; // Convert inches to cm
      }
      double heightInMeters = heightValue / 100; // Convert cm to meters

      // Convert weight to kg
      double weightValue = double.parse(_weightController.text);
      if (_weightUnit == 'lbs') {
        weightValue = weightValue * 0.453592; // Convert lbs to kg
      }

      // Calculate BMI
      double bmi = weightValue / (heightInMeters * heightInMeters);

      // Navigate to results page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultsPage(
            bmi: bmi,
            age: int.parse(_ageController.text),
            gender: _selectedGender,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BMI Calculator'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildInfoCard(),
                const SizedBox(height: 24),
                _buildGenderSelector(),
                const SizedBox(height: 24),
                _buildAgeInput(),
                const SizedBox(height: 24),
                _buildHeightInput(),
                const SizedBox(height: 24),
                _buildWeightInput(),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _calculateBMI,
                  child: const Text(
                    'CALCULATE BMI',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: const [
            Icon(Icons.info_outline, color: Colors.teal, size: 28),
            SizedBox(height: 8),
            Text(
              'Body Mass Index (BMI) is a measure of body fat based on height and weight.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderSelector() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Gender',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildGenderCard(
                    'Male',
                    Icons.male,
                    _selectedGender == 'Male',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildGenderCard(
                    'Female',
                    Icons.female,
                    _selectedGender == 'Female',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderCard(String gender, IconData icon, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedGender = gender;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.teal.withOpacity(0.2) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.teal : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 50,
              color: isSelected ? Colors.teal : Colors.grey.shade700,
            ),
            const SizedBox(height: 8),
            Text(
              gender,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.teal : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAgeInput() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Age',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _ageController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Enter your age',
                suffixText: 'years',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your age';
                }
                int? age = int.tryParse(value);
                if (age == null || age <= 0 || age > 120) {
                  return 'Please enter a valid age';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeightInput() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Height',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _heightController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Enter your height',
                      suffixText: _heightUnit,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your height';
                      }
                      double? height = double.tryParse(value);
                      if (height == null || height <= 0) {
                        return 'Please enter a valid height';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                DropdownButton<String>(
                  value: _heightUnit,
                  items: const [
                    DropdownMenuItem(value: 'cm', child: Text('cm')),
                    DropdownMenuItem(value: 'inches', child: Text('inches')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _heightUnit = value!;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeightInput() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Weight',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _weightController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Enter your weight',
                      suffixText: _weightUnit,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your weight';
                      }
                      double? weight = double.tryParse(value);
                      if (weight == null || weight <= 0) {
                        return 'Please enter a valid weight';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                DropdownButton<String>(
                  value: _weightUnit,
                  items: const [
                    DropdownMenuItem(value: 'kg', child: Text('kg')),
                    DropdownMenuItem(value: 'lbs', child: Text('lbs')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _weightUnit = value!;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ResultsPage extends StatelessWidget {
  final double bmi;
  final int age;
  final String gender;

  const ResultsPage({
    super.key,
    required this.bmi,
    required this.age,
    required this.gender,
  });

  String _getBMICategory() {
    if (bmi < 16) {
      return 'Severe Thinness';
    } else if (bmi < 17) {
      return 'Moderate Thinness';
    } else if (bmi < 18.5) {
      return 'Mild Thinness';
    } else if (bmi < 25) {
      return 'Normal';
    } else if (bmi < 30) {
      return 'Overweight';
    } else if (bmi < 35) {
      return 'Obese Class I';
    } else if (bmi < 40) {
      return 'Obese Class II';
    } else {
      return 'Obese Class III';
    }
  }

  Color _getCategoryColor() {
    String category = _getBMICategory();
    if (category == 'Normal') {
      return Colors.green;
    } else if (category.contains('Thinness')) {
      return Colors.blue;
    } else {
      return Colors.orange;
    }
  }

  String _getHealthRisk() {
    String category = _getBMICategory();
    if (category == 'Normal') {
      return 'Low risk';
    } else if (category.contains('Thinness')) {
      return 'Risk of nutritional deficiency and osteoporosis';
    } else if (category == 'Overweight') {
      return 'Moderate risk of developing heart disease, high blood pressure, stroke, diabetes';
    } else {
      return 'High risk of developing heart disease, high blood pressure, stroke, diabetes';
    }
  }

  String _getAdvice() {
    String category = _getBMICategory();
    if (category == 'Normal') {
      return 'Good job! Maintain your healthy weight with regular exercise and balanced diet.';
    } else if (category.contains('Thinness')) {
      return 'Consider gaining some weight. Focus on nutrient-dense foods and strength training.';
    } else {
      return 'Consider losing weight through increased physical activity and a balanced, calorie-controlled diet.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your BMI Results'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildResultCard(),
              const SizedBox(height: 24),
              _buildBMIScaleCard(),
              const SizedBox(height: 24),
              _buildHealthRiskCard(),
              const SizedBox(height: 24),
              _buildAdviceCard(),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'RECALCULATE',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Text(
              'Your BMI',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              bmi.toStringAsFixed(1),
              style: TextStyle(
                fontSize: 64,
                fontWeight: FontWeight.bold,
                color: _getCategoryColor(),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              decoration: BoxDecoration(
                color: _getCategoryColor().withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _getBMICategory(),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _getCategoryColor(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBMIScaleCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'BMI Categories',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildCategoryRow('Severe Thinness', '< 16', Colors.blue),
            _buildCategoryRow('Moderate Thinness', '16 - 17', Colors.blue),
            _buildCategoryRow('Mild Thinness', '17 - 18.5', Colors.blue),
            _buildCategoryRow('Normal', '18.5 - 25', Colors.green),
            _buildCategoryRow('Overweight', '25 - 30', Colors.orange),
            _buildCategoryRow('Obese Class I', '30 - 35', Colors.orange),
            _buildCategoryRow('Obese Class II', '35 - 40', Colors.orange),
            _buildCategoryRow('Obese Class III', '> 40', Colors.orange),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryRow(String category, String range, Color color) {
    bool isCurrentCategory = category == _getBMICategory();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              category,
              style: TextStyle(
                fontWeight: isCurrentCategory ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          Text(
            range,
            style: TextStyle(
              color: Colors.grey[600],
              fontWeight: isCurrentCategory ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          if (isCurrentCategory)
            const Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Icon(Icons.check_circle, color: Colors.teal, size: 16),
            ),
        ],
      ),
    );
  }

  Widget _buildHealthRiskCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Health Risk',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              _getHealthRisk(),
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdviceCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recommendation',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              _getAdvice(),
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              'Note: BMI is not the sole indicator of health. Consult with a healthcare professional for personalized advice.',
              style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}