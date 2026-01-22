// Variant Selector Widget
import 'package:flutter/material.dart';
import '../../data/models/variant_model.dart';

class VariantSelector extends StatelessWidget {
  final List<VariantModel> variants;
  final VariantModel? selectedVariant;
  final Function(VariantModel) onVariantSelected;

  const VariantSelector({
    super.key,
    required this.variants,
    this.selectedVariant,
    required this.onVariantSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Variant',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: variants.map((variant) {
            final isSelected = selectedVariant?.variantId == variant.variantId;
            return ChoiceChip(
              label: Text(variant.name ?? variant.sku ?? 'Variant'),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  onVariantSelected(variant);
                }
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}




