import 'dart:convert';
import 'dart:io';

import 'package:bitcoin_ticker/constants.dart';
import 'package:http/http.dart' as http;

class CoinAPIHelper {
  final String url;

  CoinAPIHelper(this.url);

  Future getCryptoPrice() async {
    http.Response response = await http.get(
      url,
      headers: {"X-CoinAPI-Key": kCoinApiKey},
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print(response.statusCode);
    }
  }
}
