import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicart/Controller/Place%20Oder%20Controller/place_order_controller.dart';
import 'package:medicart/View/Customer%20Screens/Order%20Success%20Screen/order_success_screen.dart';

// ignore: must_be_immutable
class PaymentScreen extends ConsumerStatefulWidget {
  bool isDoctorNeeded;
  num amount;
  String name;
  String phn;
  String city;
  String state;
  String country;
  String pin_code;
  String street_address;
  String quantity;
  String product_name;
  String img_url;
  String? code;

  PaymentScreen({
    super.key,
    required this.isDoctorNeeded,
    required this.code,
    required this.img_url,
    required this.product_name,
    required this.quantity,
    required this.state,
    required this.country,
    required this.pin_code,
    required this.street_address,
    required this.city,
    required this.phn,
    required this.name,
    required this.amount,
  });

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  String selectedMethod = '';

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final placeOrderState = ref.watch(PlaceOrderStateNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Payment Method'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(screenWidth * 0.04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Amount Card
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(screenWidth * 0.04),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Amount to Pay',
                            style: TextStyle(
                              fontSize: screenWidth * 0.04,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.01),
                          Text(
                            '₹${widget.amount.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: screenWidth * 0.06,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.03),
                    Text(
                      'Payment Options',
                      style: TextStyle(
                        fontSize: screenWidth * 0.045,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),

                    // UPI Option
                    _PaymentOption(
                      title: 'UPI Payment',
                      subtitle: 'Pay using any UPI app',
                      icon: Icons.account_balance,
                      isSelected: selectedMethod == 'upi',
                      onTap: () => setState(() => selectedMethod = 'upi'),
                    ),

                    // Card Option
                    _PaymentOption(
                      title: 'Credit/Debit Card',
                      subtitle: 'Pay using credit or debit card',
                      icon: Icons.credit_card,
                      isSelected: selectedMethod == 'card',
                      onTap: () => setState(() => selectedMethod = 'card'),
                    ),

                    // Net Banking Option
                    _PaymentOption(
                      title: 'Net Banking',
                      subtitle: 'Pay using net banking',
                      icon: Icons.account_balance_wallet,
                      isSelected: selectedMethod == 'netbanking',
                      onTap: () =>
                          setState(() => selectedMethod = 'netbanking'),
                    ),

                    // Cash on Delivery
                    _PaymentOption(
                      title: 'Cash on Delivery',
                      subtitle: 'Pay when you receive the order',
                      icon: Icons.money,
                      isSelected: selectedMethod == 'cod',
                      onTap: () => setState(() => selectedMethod = 'cod'),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Bottom Payment Button
          Container(
            padding: EdgeInsets.all(screenWidth * 0.04),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: selectedMethod.isEmpty || placeOrderState.isloading
                    ? null
                    : () async {
                        if (selectedMethod == 'cod') {
                          if (widget.isDoctorNeeded) {
                            log(widget.isDoctorNeeded.toString());
                            ref
                                .read(PlaceOrderStateNotifierProvider.notifier)
                                .onPlaceOrderWithPresc(
                                    isDocApproved: false,
                                    code: widget.code,
                                    payment_method: "COD",
                                    img_url: widget.img_url,
                                    userId:
                                        FirebaseAuth.instance.currentUser!.uid,
                                    name: widget.name,
                                    phn: widget.phn,
                                    city: widget.city,
                                    State: widget.state,
                                    country: widget.country,
                                    pin_code: widget.pin_code,
                                    street_address: widget.street_address,
                                    amount: widget.amount,
                                    product_name: widget.product_name,
                                    qnt: widget.quantity);

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const OrderSuccessScreen(),
                              ),
                            );
                          } else {
                            log(widget.isDoctorNeeded.toString());
                            ref
                                .read(PlaceOrderStateNotifierProvider.notifier)
                                .onPlaceOrder(
                                    code: widget.code,
                                    payment_method: "COD",
                                    img_url: widget.img_url,
                                    userId:
                                        FirebaseAuth.instance.currentUser!.uid,
                                    name: widget.name,
                                    phn: widget.phn,
                                    city: widget.city,
                                    State: widget.state,
                                    country: widget.country,
                                    pin_code: widget.pin_code,
                                    street_address: widget.street_address,
                                    amount: widget.amount,
                                    product_name: widget.product_name,
                                    qnt: widget.quantity);

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const OrderSuccessScreen(),
                              ),
                            );
                          }
                        } else {
                          // Handle other payment methods
                          switch (selectedMethod) {
                            case 'upi':
                              // Handle UPI payment
                              break;
                            case 'card':
                              // Handle card payment
                              break;
                            case 'netbanking':
                              // Handle net banking
                              break;
                          }
                        }
                      },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                child: ref.watch(PlaceOrderStateNotifierProvider).isloading
                    ? CircularProgressIndicator()
                    : Text(
                        selectedMethod == 'cod' ? 'Place Order' : 'Pay Now',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenWidth * 0.045,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom Payment Option Widget (unchanged)
class _PaymentOption extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _PaymentOption({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected
                  ? Theme.of(context).primaryColor
                  : Colors.grey[300]!,
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 28,
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : Colors.grey[600],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isSelected
                            ? Theme.of(context).primaryColor
                            : Colors.black,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: Theme.of(context).primaryColor,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
