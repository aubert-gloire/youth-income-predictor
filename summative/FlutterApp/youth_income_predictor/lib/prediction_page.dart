import 'package:flutter/material.dart';
import 'api_service.dart';
import 'main.dart'; // for color constants

// If importing from main.dart does not work, define kIconGraph here:
// const kIconGraph = Color(0xFF2979FF); // Blue

const kBgStart = Color(0xFF181A24);
const kBgEnd = Color(0xFF23242A);
const kCard = Color(0xFF23242A);
const kPrimary = Color(0xFF7B4FFF);
const kAccent = Color(0xFFFF9100);
const kText = Colors.white;
const kTextSecondary = Color(0xFFB0B0C3);

// Icon colors for form fields
const kIconAge = kAccent; // Orange
const kIconGender = Color(0xFF2979FF); // Blue
const kIconEducation = Color(0xFFFFD600); // Yellow
const kIconRegion = Color(0xFF1DE9B6); // Teal
const kIconEmpRate = Color(0xFF00E676); // Green
const kIconUnempRate = Color(0xFFFF5252); // Red
const kIconHousehold = Color(0xFF7B4FFF); // Purple
const kIconDigital = Color(0xFF00BFAE); // Cyan
const kIconTraining = Color(0xFF7C4DFF); // Deep purple
const kIconIncome = Color(0xFFFF4081); // Pink

class PredictionPage extends StatefulWidget {
  const PredictionPage({super.key});
  @override
  PredictionPageState createState() => PredictionPageState();
}

class PredictionPageState extends State<PredictionPage> with SingleTickerProviderStateMixin {
  // Helper for text fields with icon
  Widget _buildIconField(IconData icon, String label, String key, TextInputType type, Color iconColor, {String? hint, String? Function(String?)? validator}) {
    TextEditingController? controller;
    if (key == 'age') controller = _ageController;
    if (key == 'region_employment_rate') controller = _regionEmploymentRateController;
    if (key == 'regional_unemployment_rate') controller = _regionalUnemploymentRateController;
    if (key == 'household_size') controller = _householdSizeController;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Container(
        decoration: BoxDecoration(
          color: kCard,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.7),
              blurRadius: 12,
              offset: const Offset(6, 6),
            ),
            BoxShadow(
              color: Colors.white.withValues(alpha: 0.04),
              blurRadius: 6,
              offset: const Offset(-4, -4),
            ),
          ],
        ),
        child: TextFormField(
          controller: controller,
          keyboardType: type,
          style: const TextStyle(color: kText, fontSize: 13, fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            prefixIcon: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.18),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 18),
            ),
            labelText: label,
            labelStyle: const TextStyle(color: kText, fontWeight: FontWeight.bold, fontSize: 13),
            hintText: hint,
            hintStyle: const TextStyle(color: kTextSecondary, fontSize: 11),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
          ),
          validator: validator,
          onSaved: (val) => _formData[key] = val ?? '',
        ),
      ),
    );
  }

  // Helper for dropdowns with icon
  Widget _buildIconDropdown(IconData icon, String label, String key, List<String> options, Color iconColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Container(
        decoration: BoxDecoration(
          color: kCard,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.7),
              blurRadius: 12,
              offset: const Offset(6, 6),
            ),
            BoxShadow(
              color: Colors.white.withValues(alpha: 0.04),
              blurRadius: 6,
              offset: const Offset(-4, -4),
            ),
          ],
        ),
        child: DropdownButtonFormField<String>(
          key: ValueKey('${key}_${_formData[key] ?? ""}_${_result ?? ""}_${_error ?? ""}'),
          decoration: InputDecoration(
            prefixIcon: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.18),
                shape: BoxShape.circle,
                boxShadow: [
                  if (iconColor == kAccent)
                    BoxShadow(
                      color: kAccent.withValues(alpha: 0.5),
                      blurRadius: 16,
                      spreadRadius: 2,
                    ),
                ],
              ),
              child: Icon(icon, color: iconColor, size: 18),
            ),
            labelText: label,
            labelStyle: const TextStyle(color: kText, fontWeight: FontWeight.bold, fontSize: 13),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
          ),
          dropdownColor: kCard,
          style: const TextStyle(color: kText, fontSize: 13, fontWeight: FontWeight.w500),
          value: (_formData[key] == null || _formData[key] == '') ? null : _formData[key],
          items: options.map((opt) => DropdownMenuItem(value: opt, child: Text(opt, style: const TextStyle(fontSize: 13)))).toList(),
          onChanged: (val) => setState(() => _formData[key] = val ?? ''),
          validator: (v) => (v == null || v.isEmpty) ? 'Select $label' : null,
        ),
      ),
    );
  }

  Future<void> _predict() async {
    setState(() {
      _loading = true;
      _result = null;
      _error = null;
    });
    _resultAnimController?.reset();
    try {
      final input = {
        'age': int.tryParse(_ageController.text) ?? 0,
        'gender': _formData['gender'],
        'education_level': _formData['education_level'],
        'region': _formData['region'],
        'region_employment_rate': double.tryParse(_regionEmploymentRateController.text) ?? 0.0,
        'regional_unemployment_rate': double.tryParse(_regionalUnemploymentRateController.text) ?? 0.0,
        'household_size': int.tryParse(_householdSizeController.text) ?? 0,
        'digital_skills_level': _formData['digital_skills_level'],
        'training_participation': _formData['training_participation'] == 'Yes',
        'household_income': _formData['household_income'],
      };
      final data = await ApiService.predictIncome(input);
      if (!mounted) return;
      final resultText = 'Predicted Monthly Income: '
          '${data['predicted_monthly_income']?.toStringAsFixed(2) ?? data['predicted_monthly_income']} RWF';
      setState(() {
        _result = resultText;
      });
      _resultAnimController?.forward();
      // Show dialog popup with result
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: kCard,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            title: const Text('Prediction Result', style: TextStyle(color: kAccent, fontWeight: FontWeight.bold)),
            content: Text(resultText, style: const TextStyle(color: kText, fontSize: 15, fontWeight: FontWeight.bold)),
            actions: [
              TextButton(
                child: const Text('OK', style: TextStyle(color: kAccent, fontWeight: FontWeight.bold)),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        },
      );
    } catch (e) {
      setState(() {
        _error = 'Error: $e';
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {
    'gender': null,
    'education_level': null,
    'region': null,
    'digital_skills_level': null,
    'training_participation': null,
    'household_income': null,
  };
  // Controllers for text fields
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _regionEmploymentRateController = TextEditingController();
  final TextEditingController _regionalUnemploymentRateController = TextEditingController();
  final TextEditingController _householdSizeController = TextEditingController();
  String? _result;
  String? _error;
  bool _loading = false;
  AnimationController? _resultAnimController;
  Animation<double>? _resultFadeAnim;

  @override
  void initState() {
    super.initState();
    _resultAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _resultFadeAnim = CurvedAnimation(
      parent: _resultAnimController!,
      curve: Curves.easeIn,
    );
    // Initialize controllers to empty
    _ageController.text = '';
    _regionEmploymentRateController.text = '';
    _regionalUnemploymentRateController.text = '';
    _householdSizeController.text = '';
  }

  @override
  void dispose() {
    _resultAnimController?.dispose();
    _ageController.dispose();
    _regionEmploymentRateController.dispose();
    _regionalUnemploymentRateController.dispose();
    _householdSizeController.dispose();
    super.dispose();
  }

  void _fillSampleData() {
    setState(() {
      _ageController.text = '22';
      _regionEmploymentRateController.text = '75';
      _regionalUnemploymentRateController.text = '15';
      _householdSizeController.text = '4';
      _formData['gender'] = 'Male';
      _formData['education_level'] = 'University';
      _formData['region'] = 'Kigali';
      _formData['digital_skills_level'] = 'Advanced';
      _formData['training_participation'] = 'Yes';
      _formData['household_income'] = 'Medium';
    });
  }

  void _clearForm() {
    setState(() {
      // Clear text controllers
      _ageController.clear();
      _regionEmploymentRateController.clear();
      _regionalUnemploymentRateController.clear();
      _householdSizeController.clear();
      // Reset dropdown values
      _formData['gender'] = null;
      _formData['education_level'] = null;
      _formData['region'] = null;
      _formData['digital_skills_level'] = null;
      _formData['training_participation'] = null;
      _formData['household_income'] = null;
      // Clear results
      _result = null;
      _error = null;
    });
    // Remove keyboard focus
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: kCard,
        elevation: 0,
        title: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: kIconGraph.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(8),
              child: Icon(Icons.analytics, color: kIconGraph, size: 32),
            ),
            const SizedBox(width: 14),
            const Text(
              'Income Prediction',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: kText),
            ),
          ],
        ),
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [kBgStart, kBgEnd],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: kCard,
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.7),
              blurRadius: 16,
              offset: const Offset(8, 8),
            ),
            BoxShadow(
              color: Colors.white.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(-6, -6),
            ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                              color: kAccent.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              padding: const EdgeInsets.all(10),
                              child: Icon(Icons.analytics, color: kAccent, size: 28),
                            ),
                            const SizedBox(width: 14),
                            const Text(
                              'Youth Income Data Input',
                              style: TextStyle(
                                color: kText,
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        // --- Form Fields ---
                        _buildIconField(
                          Icons.cake,
                          'Age',
                          'age',
                          TextInputType.number,
                          kIconAge,
                          hint: 'Enter your age (22-30)',
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Enter age (22-30)';
                            final n = int.tryParse(v);
                            if (n == null || n <= 0) return 'Enter a valid age (> 0)';
                            if (n < 22 || n > 30) return 'Recommended: Enter an age between 22 and 30';
                            return null;
                          },
                        ),
                        _buildIconDropdown(
                          Icons.male,
                          'Gender',
                          'gender',
                          ['Male', 'Female'],
                          kIconGender,
                        ),
                        _buildIconDropdown(
                          Icons.school,
                          'Education Level',
                          'education_level',
                          ['None', 'Primary', 'Secondary', 'University'],
                          kIconEducation,
                        ),
                        _buildIconDropdown(
                          Icons.location_city,
                          'Region',
                          'region',
                          ['Kigali', 'Northern', 'Southern', 'Eastern', 'Western'],
                          kIconRegion,
                        ),
                        _buildIconField(
                          Icons.bar_chart,
                          'Region Employment Rate (%)',
                          'region_employment_rate',
                          TextInputType.number,
                          kIconEmpRate,
                          hint: 'e.g. 70-90',
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Enter employment rate (70-90)';
                            final n = double.tryParse(v);
                            if (n == null || n < 0 || n > 100) return 'Enter a value between 0 and 100';
                            if (n < 70 || n > 90) return 'Recommended: Enter a rate between 70 and 90';
                            return null;
                          },
                        ),
                        _buildIconField(
                          Icons.trending_down,
                          'Regional Unemployment Rate (%)',
                          'regional_unemployment_rate',
                          TextInputType.number,
                          kIconUnempRate,
                          hint: 'e.g. 10-20',
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Enter unemployment rate (10-20)';
                            final n = double.tryParse(v);
                            if (n == null || n < 0 || n > 100) return 'Enter a value between 0 and 100';
                            if (n < 10 || n > 20) return 'Recommended: Enter a rate between 10 and 20';
                            return null;
                          },
                        ),
                        _buildIconField(
                          Icons.people,
                          'Household Size',
                          'household_size',
                          TextInputType.number,
                          kIconHousehold,
                          hint: 'e.g. 3-6',
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Enter household size (3-6)';
                            final n = int.tryParse(v);
                            if (n == null || n <= 0) return 'Enter a valid size (> 0)';
                            if (n < 3 || n > 6) return 'Recommended: Enter a size between 3 and 6';
                            return null;
                          },
                        ),
                        _buildIconDropdown(
                          Icons.computer,
                          'Digital Skills Level',
                          'digital_skills_level',
                          ['None', 'Basic', 'Intermediate', 'Advanced'],
                          kIconDigital,
                        ),
                        _buildIconDropdown(
                          Icons.school_outlined,
                          'Training Participation',
                          'training_participation',
                          ['Yes', 'No'],
                          kIconTraining,
                        ),
                        _buildIconDropdown(
                          Icons.attach_money,
                          'Household Income',
                          'household_income',
                          ['Low', 'Medium', 'High'],
                          kIconIncome,
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            OutlinedButton.icon(
                              icon: const Icon(Icons.auto_fix_high, color: kAccent),
                              label: const Text('Sample Data', style: TextStyle(color: kAccent)),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: kAccent, width: 1.5),
                                shape: const StadiumBorder(),
                                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
                                backgroundColor: kCard,
                              ),
                              onPressed: _fillSampleData,
                            ),
                            const SizedBox(width: 18),
                            OutlinedButton.icon(
                              icon: const Icon(Icons.clear, color: Colors.redAccent),
                              label: const Text('Clear', style: TextStyle(color: Colors.redAccent)),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Colors.redAccent, width: 1.5),
                                shape: const StadiumBorder(),
                                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
                                backgroundColor: kCard,
                              ),
                              onPressed: _clearForm,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 36),
                  // --- Predict Button ---
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    child: Center(
                      child: Container(
                        width: double.infinity,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(32),
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFF44464A), Color(0xFF181A24)],
                          ),
                          border: Border.all(
                            color: const Color.fromARGB(31, 255, 255, 255),
                            width: 1.2,
                          ),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(32),
                            onTap: _loading
                                ? null
                                : () {
                                    if (_formKey.currentState!.validate()) {
                                      _formKey.currentState!.save();
                                      _predict();
                                    }
                                  },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _loading
                                    ? const SizedBox(
                                        width: 28,
                                        height: 28,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 3,
                                        ),
                                      )
                                    : const Icon(Icons.analytics, color: Colors.white, size: 28),
                                const SizedBox(width: 12),
                                const Text(
                                  'Predict',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  if (_result != null)
                    FadeTransition(
                      opacity: _resultFadeAnim!,
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: kAccent.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Text(
                          _result!,
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: kAccent),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  if (_error != null)
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Text(
                        _error!,
                        style: const TextStyle(fontSize: 13, color: Colors.redAccent),
                        textAlign: TextAlign.center,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

}
