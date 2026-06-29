// lib/core/widgets/currency_picker_sheet.dart
import 'package:flutter/material.dart';
import 'package:noble_invoice/core/theme/app_colors.dart';
import 'package:noble_invoice/core/constants/currency_constants.dart';

class CurrencyPickerSheet extends StatefulWidget {
  final String currentCurrency;
  final ValueChanged<String> onSelect;

  const CurrencyPickerSheet({
    super.key,
    required this.currentCurrency,
    required this.onSelect,
  });

  @override
  State<CurrencyPickerSheet> createState() => _CurrencyPickerSheetState();
}

class _CurrencyPickerSheetState extends State<CurrencyPickerSheet> {
  String _searchQuery = '';
  late List<MapEntry<String, String>> _filteredCurrencies;

  @override
  void initState() {
    super.initState();
    _filteredCurrencies = worldCurrencies.entries.toList();
  }

  void _filterCurrencies(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
      _filteredCurrencies = worldCurrencies.entries.where((entry) {
        final code = entry.key.toLowerCase();
        final name = entry.value.toLowerCase();
        return code.contains(_searchQuery) || name.contains(_searchQuery);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Drag handle
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.lightGrey,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Select Currency',
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, color: AppColors.darkGrey),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              onChanged: _filterCurrencies,
              decoration: InputDecoration(
                hintText: 'Search currency code or name...',
                prefixIcon: const Icon(Icons.search_rounded, color: AppColors.darkGrey),
                filled: true,
                fillColor: AppColors.lightGrey.withOpacity(0.3),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),
          const SizedBox(height: 12),
          
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 24),
              itemCount: _filteredCurrencies.length,
              itemBuilder: (context, index) {
                final entry = _filteredCurrencies[index];
                final isSelected = entry.key == widget.currentCurrency;
                
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                  leading: CircleAvatar(
                    backgroundColor: isSelected ? AppColors.primary : AppColors.lightGrey.withOpacity(0.3),
                    child: Text(
                      entry.key[0],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : AppColors.darkGrey,
                      ),
                    ),
                  ),
                  title: Text(
                    '${entry.key} - ${entry.value}',
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600,
                      color: isSelected ? AppColors.primary : AppColors.black,
                    ),
                  ),
                  trailing: isSelected 
                      ? const Icon(Icons.check_circle_rounded, color: AppColors.primary)
                      : null,
                  onTap: () {
                    widget.onSelect(entry.key);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
