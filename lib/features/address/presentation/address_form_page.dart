import 'package:flutter/material.dart';

class AddressFormPage extends StatelessWidget {
  final String? addressId;

  const AddressFormPage({
    super.key,
    this.addressId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(addressId != null ? 'Edit Address' : 'Add Address'),
      ),
      body: Center(
        child: Text(
          addressId != null 
            ? 'Edit Address for ID: $addressId'
            : 'Add New Address',
        ),
      ),
    );
  }
}
