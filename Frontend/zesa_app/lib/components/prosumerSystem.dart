import 'dart:math' as math;

import 'package:flutter/material.dart';

class SolarSystemSetupForm extends StatefulWidget {
  final Function(Map<String, dynamic>) onSave;
  final Map<String, dynamic>? initialData;

  const SolarSystemSetupForm({
    Key? key,
    required this.onSave,
    this.initialData,
  }) : super(key: key);

  @override
  State<SolarSystemSetupForm> createState() => _SolarSystemSetupFormState();
}

class _SolarSystemSetupFormState extends State<SolarSystemSetupForm> with TickerProviderStateMixin {
  late AnimationController _glowController;
  late AnimationController _floatController;
  
  final _formKey = GlobalKey<FormState>();
  
  // Form controllers
  final _panelCountController = TextEditingController();
  final _panelVoltsController = TextEditingController();
  final _panelWattsController = TextEditingController();
  final _inverterCapacityController = TextEditingController();
  final _batteryCapacityController = TextEditingController();
  final _batteryVoltageController = TextEditingController();
  
  DateTime? _installationDate;
  String _selectedPanelType = 'Monocrystalline';
  String _selectedInverterType = 'Hybrid';
  int _currentStep = 0;

  final List<String> _panelTypes = [
    'Monocrystalline',
    'Polycrystalline',
    'Thin Film',
    'PERC',
  ];

  final List<String> _inverterTypes = [
    'Hybrid',
    'Grid-Tie',
    'Off-Grid',
    'Microinverter',
  ];

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    // Load initial data if provided
    if (widget.initialData != null) {
      _loadInitialData(widget.initialData!);
    }
  }

  void _loadInitialData(Map<String, dynamic> data) {
    _panelCountController.text = data['panelCount']?.toString() ?? '';
    _panelVoltsController.text = data['panelVolts']?.toString() ?? '';
    _panelWattsController.text = data['panelWatts']?.toString() ?? '';
    _inverterCapacityController.text = data['inverterCapacity']?.toString() ?? '';
    _batteryCapacityController.text = data['batteryCapacity']?.toString() ?? '';
    _batteryVoltageController.text = data['batteryVoltage']?.toString() ?? '';
    _selectedPanelType = data['panelType'] ?? 'Monocrystalline';
    _selectedInverterType = data['inverterType'] ?? 'Hybrid';
    if (data['installationDate'] != null) {
      _installationDate = DateTime.parse(data['installationDate']);
    }
  }

  @override
  void dispose() {
    _glowController.dispose();
    _floatController.dispose();
    _panelCountController.dispose();
    _panelVoltsController.dispose();
    _panelWattsController.dispose();
    _inverterCapacityController.dispose();
    _batteryCapacityController.dispose();
    _batteryVoltageController.dispose();
    super.dispose();
  }

  double _calculateTotalCapacity() {
    final count = int.tryParse(_panelCountController.text) ?? 0;
    final watts = double.tryParse(_panelWattsController.text) ?? 0;
    return (count * watts) / 1000; // Convert to kW
  }

   String _getSystemAge() {
    if (_installationDate == null) return '--';
    final difference = DateTime.now().difference(_installationDate!);
    final years = difference.inDays ~/ 365;
    final months = (difference.inDays % 365) ~/ 30;
    if (years > 0) return '$years yr${years > 1 ? 's' : ''} $months mo';
    return '$months month${months != 1 ? 's' : ''}';
  }

  void _handleSave() {
    if (_formKey.currentState!.validate()) {
      final data = {
        'panelCount': int.tryParse(_panelCountController.text) ?? 0,
        'panelVolts': double.tryParse(_panelVoltsController.text) ?? 0,
        'panelWatts': double.tryParse(_panelWattsController.text) ?? 0,
        'panelType': _selectedPanelType,
        'inverterCapacity': double.tryParse(_inverterCapacityController.text) ?? 0,
        'inverterType': _selectedInverterType,
        'batteryCapacity': double.tryParse(_batteryCapacityController.text) ?? 0,
        'batteryVoltage': double.tryParse(_batteryVoltageController.text) ?? 0,
        'installationDate': _installationDate?.toIso8601String(),
        'totalCapacity': _calculateTotalCapacity(),
      };
      widget.onSave(data);
    }
  }

  Widget _buildHeader(){
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          AnimatedBuilder(
            animation: _floatController,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, math.sin(_floatController.value * math.pi * 2) * 5),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFF00d9ff).withOpacity(0.3),
                        Colors.transparent,
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.solar_power,
                    size: 48,
                    color: const Color(0xFF00d9ff),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          Text(
            'Solar System Setup',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Configure your solar energy system',
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            children: List.generate(5, (index) {
              final isActive = index <= _currentStep;
              final isComplete = index < _currentStep;
              
              return Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        height: 4,
                        decoration: BoxDecoration(
                          gradient: isActive
                              ? LinearGradient(
                                  colors: [
                                    const Color(0xFF00d9ff),
                                    const Color(0xFF00ff88),
                                  ],
                                )
                              : null,
                          color: isActive ? null : Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    if (index < 4) const SizedBox(width: 4),
                  ],
                ),
              );
            }),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStepLabel('Panels', 0),
              _buildStepLabel('Inverter', 1),
              _buildStepLabel('Battery', 2),
              _buildStepLabel('Install', 3),
              _buildStepLabel('Review', 4),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStepLabel(String label, int step) {
    final isActive = step == _currentStep;
    return Text(
      label,
      style: TextStyle(
        color: isActive ? const Color(0xFF00d9ff) : Colors.white.withOpacity(0.4),
        fontSize: 11,
        fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
      ),
    );
  }

  Widget _buildPanelSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        _buildSectionTitle('Solar Panel Configuration', Icons.solar_power),
        const SizedBox(height: 20),
        
        _buildInputField(
          controller: _panelCountController,
          label: 'Number of Panels',
          hint: 'e.g., 12',
          icon: Icons.grid_on,
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) return 'Required';
            if (int.tryParse(value) == null || int.parse(value) <= 0) {
              return 'Enter valid number';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        
        Row(
          children: [
            Expanded(
              child: _buildInputField(
                controller: _panelVoltsController,
                label: 'Panel Voltage (V)',
                hint: 'e.g., 24',
                icon: Icons.bolt,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Required';
                  if (double.tryParse(value) == null) return 'Invalid';
                  return null;
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildInputField(
                controller: _panelWattsController,
                label: 'Panel Wattage (W)',
                hint: 'e.g., 450',
                icon: Icons.flash_on,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Required';
                  if (double.tryParse(value) == null) return 'Invalid';
                  return null;
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        _buildDropdownField(
          label: 'Panel Type',
          value: _selectedPanelType,
          items: _panelTypes,
          icon: Icons.category,
          onChanged: (value) {
            setState(() {
              _selectedPanelType = value!;
            });
          },
        ),
        
        const SizedBox(height: 20),
        _buildCapacityPreview(),
      ],
    );
  }

  Widget _buildInverterSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        _buildSectionTitle('Inverter Configuration', Icons.power),
        const SizedBox(height: 20),
        
        _buildInputField(
          controller: _inverterCapacityController,
          label: 'Inverter Capacity (kVA)',
          hint: 'e.g., 5.0',
          icon: Icons.electric_bolt,
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) return 'Required';
            if (double.tryParse(value) == null || double.parse(value) <= 0) {
              return 'Enter valid capacity';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        
        _buildDropdownField(
          label: 'Inverter Type',
          value: _selectedInverterType,
          items: _inverterTypes,
          icon: Icons.settings_input_component,
          onChanged: (value) {
            setState(() {
              _selectedInverterType = value!;
            });
          },
        ),
        
        const SizedBox(height: 20),
        _buildInfoCard(
          'Hybrid inverters allow seamless switching between solar, battery, and grid power sources.',
          Icons.info_outline,
          const Color(0xFF00d9ff),
        ),
      ],
    );
  }

   Widget _buildBatterySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        _buildSectionTitle('Battery Configuration', Icons.battery_charging_full),
        const SizedBox(height: 20),
        
        _buildInputField(
          controller: _batteryCapacityController,
          label: 'Battery Capacity (Ah)',
          hint: 'e.g., 200',
          icon: Icons.battery_std,
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) return 'Required';
            if (double.tryParse(value) == null || double.parse(value) <= 0) {
              return 'Enter valid capacity';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        
        _buildInputField(
          controller: _batteryVoltageController,
          label: 'Battery Voltage (V)',
          hint: 'e.g., 48',
          icon: Icons.bolt,
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) return 'Required';
            if (double.tryParse(value) == null) return 'Invalid';
            return null;
          },
        ),
        
        const SizedBox(height: 20),
        _buildStorageCapacityCard(),
      ],
    );
  }

  Widget _buildInstallationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        _buildSectionTitle('Installation Details', Icons.calendar_today),
        const SizedBox(height: 20),
        
        GestureDetector(
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: _installationDate ?? DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime.now(),
              builder: (context, child) {
                return Theme(
                  data: ThemeData.dark().copyWith(
                    colorScheme: ColorScheme.dark(
                      primary: const Color(0xFF00d9ff),
                      surface: const Color(0xFF16213e),
                    ),
                  ),
                  child: child!,
                );
              },
            );
            if (date != null) {
              setState(() {
                _installationDate = date;
              });
            }
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFF00d9ff).withOpacity(0.3),
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00d9ff).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.event,
                    color: const Color(0xFF00d9ff),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Installation Date',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _installationDate != null
                            ? '${_installationDate!.day}/${_installationDate!.month}/${_installationDate!.year}'
                            : 'Tap to select date',
                        style: TextStyle(
                          color: _installationDate != null
                              ? Colors.white
                              : Colors.white.withOpacity(0.4),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white.withOpacity(0.3),
                  size: 16,
                ),
              ],
            ),
          ),
        ),
        
        if (_installationDate != null) ...[
          const SizedBox(height: 20),
          _buildSystemAgeCard(),
        ],
      ],
    );
  }

  Widget _buildReviewSection() {
    final totalCapacity = _calculateTotalCapacity();
    final batteryCapacity = double.tryParse(_batteryCapacityController.text) ?? 0;
    final batteryVoltage = double.tryParse(_batteryVoltageController.text) ?? 0;
    final storageCapacity = (batteryCapacity * batteryVoltage) / 1000;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        _buildSectionTitle('System Overview', Icons.check_circle_outline),
        const SizedBox(height: 20),
        
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF00d9ff).withOpacity(0.1),
                const Color(0xFF00ff88).withOpacity(0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFF00d9ff).withOpacity(0.3),
              width: 2,
            ),
          ),
          child: Column(
            children: [
              // Total capacity highlight
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.solar_power,
                      color: const Color(0xFF00d9ff),
                      size: 32,
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total System Capacity',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${totalCapacity.toStringAsFixed(2)} kW',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
              Divider(color: Colors.white.withOpacity(0.1)),
              const SizedBox(height: 20),
              
              _buildReviewItem(
                'Solar Panels',
                '${_panelCountController.text} × ${_panelWattsController.text}W $_selectedPanelType',
                Icons.solar_power,
              ),
              const SizedBox(height: 16),
              _buildReviewItem(
                'Inverter',
                '${_inverterCapacityController.text} kVA $_selectedInverterType',
                Icons.power,
              ),
              const SizedBox(height: 16),
              _buildReviewItem(
                'Battery Storage',
                '${storageCapacity.toStringAsFixed(2)} kWh (${_batteryCapacityController.text}Ah @ ${_batteryVoltageController.text}V)',
                Icons.battery_charging_full,
              ),
              const SizedBox(height: 16),
              _buildReviewItem(
                'Installation',
                _installationDate != null
                    ? '${_installationDate!.day}/${_installationDate!.month}/${_installationDate!.year} (${_getSystemAge()})'
                    : 'Not set',
                Icons.calendar_today,
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 20),
        _buildInfoCard(
          'Review your system configuration carefully before saving. You can edit these details anytime.',
          Icons.lightbulb_outline,
          const Color(0xFF00ff88),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF00d9ff).withOpacity(0.2),
                const Color(0xFF00ff88).withOpacity(0.2),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: const Color(0xFF00d9ff), size: 24),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: Colors.white.withOpacity(0.3),
              fontSize: 16,
            ),
            prefixIcon: Icon(icon, color: const Color(0xFF00d9ff)),
            filled: true,
            fillColor: Colors.white.withOpacity(0.05),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: Colors.white.withOpacity(0.1),
                width: 1.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: Colors.white.withOpacity(0.1),
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: Color(0xFF00d9ff),
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: Color(0xFFff0055),
                width: 1.5,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: Color(0xFFff0055),
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required IconData icon,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              Icon(icon, color: const Color(0xFF00d9ff)),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: value,
                    items: items.map((item) {
                      return DropdownMenuItem(
                        value: item,
                        child: Text(
                          item,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: onChanged,
                    dropdownColor: const Color(0xFF16213e),
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: Colors.white.withOpacity(0.5),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}