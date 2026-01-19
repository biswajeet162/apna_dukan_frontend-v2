// Price Widget
import 'package:flutter/material.dart';

class PriceWidget extends StatelessWidget {
  final double price;
  final double? originalPrice;
  final String currency;

  const PriceWidget({
    super.key,
    required this.price,
    this.originalPrice,
    this.currency = '₹',
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '$currency${price.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
        if (originalPrice != null && originalPrice! > price) ...[
          const SizedBox(width: 8),
          Text(
            '$currency${originalPrice!.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 14,
              decoration: TextDecoration.lineThrough,
              color: Colors.grey,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${((1 - price / originalPrice!) * 100).toStringAsFixed(0)}% OFF',
            style: TextStyle(
              fontSize: 12,
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ],
    );
  }
}

