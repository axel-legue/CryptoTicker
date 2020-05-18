import 'dart:io' show Platform;

import 'package:bitcoin_ticker/network/coin_api_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'coin_data.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrencies = currenciesList.first;
  int value = 0;

  @override
  void initState() {
    super.initState();
    getBitCoinValue();
  }

  getBitCoinValue() async {
    CoinAPIHelper apiHelper = CoinAPIHelper(
        "https://rest.coinapi.io/v1/exchangerate/BTC/$selectedCurrencies");
    updateUI(await apiHelper.getCryptoPrice());
  }

  void updateUI(dynamic cryptoData) {
    setState(() {
      print('value :' + cryptoData.toString());
      if (cryptoData == null) {
        value = 0;
      } else {
        var result = cryptoData['rate'] as double;
        value = result.toInt();
      }
    });
  }

  DropdownButton<String> getAndroidDropDown() {
    var currencies =
        currenciesList.map<DropdownMenuItem<String>>((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(value),
      );
    }).toList();

    return DropdownButton(
      value: selectedCurrencies,
      items: currencies,
      onChanged: (String newValue) {
        setState(() {
          getBitCoinValue();
          selectedCurrencies = newValue;
        });
      },
    );
  }

  CupertinoPicker getIOSPicker() {
    var currencies = currenciesList.map<Text>((String value) {
      return Text(value);
    }).toList();

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        return currenciesList[selectedIndex];
      },
      children: currencies,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Card(
              color: Colors.lightBlueAccent,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                child: Text(
                  '1 BTC = $value $selectedCurrencies',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? getIOSPicker() : getAndroidDropDown(),
          ),
        ],
      ),
    );
  }
}
