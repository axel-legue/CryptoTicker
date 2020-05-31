import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'coin_data.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = currenciesList.first;
  int value = 0;

  Map<String, String> coinValues = {};
  bool isWaiting = false;

  DropdownButton<String> getAndroidDropDown() {
    var currencies =
        currenciesList.map<DropdownMenuItem<String>>((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(value),
      );
    }).toList();

    return DropdownButton(
      value: selectedCurrency,
      items: currencies,
      onChanged: (String newValue) {
        setState(() {
          selectedCurrency = newValue;
          getData();
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
        setState(() {
          selectedCurrency = currenciesList[selectedIndex];
          getData();
        });
      },
      children: currencies,
    );
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  Column createCryptoCurrencyCard() {
    List<CryptoWidget> cryptoCards = [];
    for (var cryptoCurrency in cryptoList) {
      cryptoCards.add(
        CryptoWidget(
            value: isWaiting ? '?' : coinValues[cryptoCurrency],
            selectedCurrencies: selectedCurrency,
            cryptoCurrency: cryptoCurrency),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: cryptoCards,
    );
  }

  getData() async {
    isWaiting = true;
    try {
      var data = await CoinData().getCoinData(selectedCurrency);
      isWaiting = false;
      setState(() {
        coinValues = data;
      });
    } catch (e) {
      print(e);
    }
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
          createCryptoCurrencyCard(),
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

class CryptoWidget extends StatelessWidget {
  const CryptoWidget({
    Key key,
    @required this.value,
    @required this.selectedCurrencies,
    @required this.cryptoCurrency,
  }) : super(key: key);

  final String value;
  final String selectedCurrencies;
  final String cryptoCurrency;

  @override
  Widget build(BuildContext context) {
    return Padding(
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
            '1 $cryptoCurrency = $value $selectedCurrencies',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
