import 'package:dio/dio.dart';
import 'package:stock_prices/stock_model.dart';

class StockRepository {
  static const yourApiKey = 'L3V7D3XBWPILI8UP'; // replace with your API key
  static const chosenInterval = '30min';

  StockRepository();

  // Example of the URL:
  // https://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY&symbol=IBM&interval=5min&apikey=demo
  Future<StockModel?> getStockData(String stockLabel) async {
    Map<String, dynamic> queryParameters = {
      'function': 'TIME_SERIES_INTRADAY',
      'symbol': stockLabel,
      'interval': chosenInterval,
      'apikey': yourApiKey,
    };

    try {
      final response = await Dio().get(
        'https://www.alphavantage.co/query',
        queryParameters: queryParameters,
      );

      if (response.data is Map<String, dynamic>) {
        return StockModel.fromJson(response.data);
      } else {
        return null;
      }
    } on DioException {
      return null;
    }
  }
}
