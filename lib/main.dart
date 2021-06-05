import 'package:cryptowallet/List.dart';
import 'package:flutter/material.dart';

void main() => runApp(CryptoWallet());

class CryptoWallet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crypto Wallet',
      theme: ThemeData(
        primarySwatch: Colors.indigo
      ),
      home: AppList(),
    );
  }
}