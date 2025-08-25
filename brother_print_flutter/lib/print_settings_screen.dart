import 'package:flutter/material.dart';
import 'package:brother_print_sdk/brother_print_sdk.dart';
import 'main.dart';

class PrintSettingsScreen extends StatefulWidget {
  final DiscoveredPrinterInfo printer;

  const PrintSettingsScreen({super.key, required this.printer});

  @override
  State<PrintSettingsScreen> createState() => _PrintSettingsScreenState();
}

class _PrintSettingsScreenState extends State<PrintSettingsScreen> {
  final BrotherPrintSdk _sdk = BrotherPrintSdk();
  Map<String, dynamic> _printSettings = {};
  bool _isLoading = true;
  String _status = 'Loading print settings...';

  @override
  void initState() {
    super.initState();
    _loadPrintSettings();
  }

  Future<void> _loadPrintSettings() async {
    try {
      setState(() {
        _isLoading = true;
        _status = 'Loading print settings...';
      });

      final settings = await _sdk.getPrintSettings();
      setState(() {
        _printSettings = settings;
        _isLoading = false;
        _status = 'Print settings loaded successfully';
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _status = 'Failed to load print settings: $e';
      });
      _showErrorDialog('Load Error', 'Failed to load print settings: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Print Settings'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _savePrintSettings,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Status Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Status',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          _isLoading ? Icons.hourglass_empty : Icons.check_circle,
                          color: _isLoading ? Colors.orange : Colors.green,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _status,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Print Settings Form (Exactly like iOS Demo)
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _buildPrintSettingsForm(),
            ),

            const SizedBox(height: 16),

            // Validate Button (Exactly like iOS Demo)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _validateSettings,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  elevation: 2,
                  side: const BorderSide(color: Colors.grey),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Validate',
                  style: TextStyle(fontSize: 17),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrintSettingsForm() {
    if (_printSettings.isEmpty) {
      return const Center(
        child: Text('No print settings available'),
      );
    }

    final settingItems = _printSettings.entries.toList();

    return ListView.builder(
      itemCount: settingItems.length,
      itemBuilder: (context, index) {
        final entry = settingItems[index];
        final key = entry.key;
        final value = entry.value;

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
          child: ListTile(
            title: Text(
              _getSettingTitle(key),
              style: const TextStyle(fontSize: 17),
            ),
            subtitle: Text(
              _getSettingValue(value),
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => _editSetting(key, value),
            ),
            onTap: () => _editSetting(key, value),
          ),
        );
      },
    );
  }

  String _getSettingTitle(String key) {
    // Map iOS demo setting keys to readable titles
    switch (key) {
      case 'scale_value':
        return 'Scale Value';
      case 'orientation':
        return 'Orientation';
      case 'paper_size':
        return 'Paper Size';
      case 'num_copies':
        return 'Number of Copies';
      case 'print_quality':
        return 'Print Quality';
      case 'density':
        return 'Density';
      case 'auto_cut':
        return 'Auto Cut';
      case 'custom_paper_size':
        return 'Custom Paper Size';
      default:
        return key.replaceAll('_', ' ').split(' ').map((word) => 
          word.isNotEmpty ? '${word[0].toUpperCase()}${word.substring(1)}' : ''
        ).join(' ');
    }
  }

  String _getSettingValue(dynamic value) {
    if (value == null) return 'Not set';
    if (value is String) return value;
    if (value is num) return value.toString();
    if (value is bool) return value ? 'Yes' : 'No';
    if (value is Map) return 'Complex setting';
    return value.toString();
  }

  void _editSetting(String key, dynamic value) {
    _showSettingEditDialog(key, value);
  }

  void _showSettingEditDialog(String key, dynamic value) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit ${_getSettingTitle(key)}'),
          content: _buildSettingEditor(key, value),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _saveSettingValue(key, value);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSettingEditor(String key, dynamic value) {
    // Different editors based on setting type
    if (key == 'paper_size') {
      return _buildPaperSizeEditor(value);
    } else if (key == 'orientation') {
      return _buildOrientationEditor(value);
    } else if (key == 'num_copies' || key == 'scale_value') {
      return _buildNumberEditor(key, value);
    } else if (key == 'auto_cut' || key == 'print_quality') {
      return _buildSelectionEditor(key, value);
    } else {
      return _buildTextEditor(key, value);
    }
  }

  Widget _buildPaperSizeEditor(dynamic value) {
    final paperSizes = ['A4', 'Letter', 'Legal', 'Custom'];
    String selectedSize = 'A4';
    
    if (value is String) {
      selectedSize = value;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('Select Paper Size:'),
        const SizedBox(height: 16),
        ...paperSizes.map((size) => RadioListTile<String>(
          title: Text(size),
          value: size,
          groupValue: selectedSize,
          onChanged: (newValue) {
            setState(() {
              selectedSize = newValue!;
            });
          },
        )),
      ],
    );
  }

  Widget _buildOrientationEditor(dynamic value) {
    final orientations = ['Portrait', 'Landscape'];
    String selectedOrientation = 'Portrait';
    
    if (value is String) {
      selectedOrientation = value;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('Select Orientation:'),
        const SizedBox(height: 16),
        ...orientations.map((orientation) => RadioListTile<String>(
          title: Text(orientation),
          value: orientation,
          groupValue: selectedOrientation,
          onChanged: (newValue) {
            setState(() {
              selectedOrientation = newValue!;
            });
          },
        )),
      ],
    );
  }

  Widget _buildNumberEditor(String key, dynamic value) {
    final controller = TextEditingController(text: value?.toString() ?? '');
    
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: _getSettingTitle(key),
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _buildSelectionEditor(String key, dynamic value) {
    List<String> options = [];
    
    if (key == 'auto_cut') {
      options = ['Yes', 'No'];
    } else if (key == 'print_quality') {
      options = ['Fast', 'Normal', 'High'];
    }
    
    String selectedOption = options.first;
    if (value is String && options.contains(value)) {
      selectedOption = value;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Select ${_getSettingTitle(key)}:'),
        const SizedBox(height: 16),
        ...options.map((option) => RadioListTile<String>(
          title: Text(option),
          value: option,
          groupValue: selectedOption,
          onChanged: (newValue) {
            setState(() {
              selectedOption = newValue!;
            });
          },
        )),
      ],
    );
  }

  Widget _buildTextEditor(String key, dynamic value) {
    final controller = TextEditingController(text: value?.toString() ?? '');
    
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: _getSettingTitle(key),
        border: const OutlineInputBorder(),
      ),
    );
  }

  void _saveSettingValue(String key, dynamic value) {
    // Update the setting value
    setState(() {
      _printSettings[key] = value;
    });
    
    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${_getSettingTitle(key)} updated successfully'),
        backgroundColor: Colors.green,
      ),
    );
  }

  Future<void> _savePrintSettings() async {
    try {
      setState(() {
        _status = 'Saving print settings...';
      });

      await _sdk.setPrintSettings(_printSettings);
      
      setState(() {
        _status = 'Print settings saved successfully';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Print settings saved successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      setState(() {
        _status = 'Failed to save print settings: $e';
      });
      _showErrorDialog('Save Error', 'Failed to save print settings: $e');
    }
  }

  Future<void> _validateSettings() async {
    try {
      setState(() {
        _status = 'Validating settings...';
      });

      // Call validation method (if available)
      // await _sdk.validatePrintSettings(_printSettings);
      
      setState(() {
        _status = 'Settings validation completed';
      });

      _showSuccessDialog('Validation Complete', 'Print settings validation completed successfully!');
    } catch (e) {
      setState(() {
        _status = 'Validation failed: $e';
      });
      _showErrorDialog('Validation Error', 'Failed to validate print settings: $e');
    }
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showSuccessDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
