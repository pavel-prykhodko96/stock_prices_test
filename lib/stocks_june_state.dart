import 'package:june/june.dart';
import 'package:stock_prices/stock_model.dart';
import 'package:stock_prices/stocks_repository.dart';

enum StocksLoadingStatus {
  loading,
  done,
  error,
}

class StocksJuneState extends JuneState {
  static const List<String> _stockLabels = ['IBM', 'AAPL', 'GOOGL', 'AMZN'];
  final StockRepository _stocksRepository =
      StockRepository(); // it is better to use DI for such cases

  StocksLoadingStatus _status = StocksLoadingStatus.loading;
  List<StockModel> _stocks = [];

  StocksLoadingStatus get status => _status;
  List<StockModel> get stocks => _stocks;

  StocksJuneState() {
    fetchStocks();
  }

  Future<void> fetchStocks() async {
    _status = StocksLoadingStatus.loading;
    setState();

    try {
      List<StockModel> stocks = [];

      await Future.wait<StockModel?>(
        _stockLabels.map((e) => _stocksRepository.getStockData(e)),
      ).then(
        (results) {
          stocks = results
              .where(
                (element) => element != null,
              )
              .map(
                (e) => e!,
              )
              .toList();
          _status = StocksLoadingStatus.done;
          _stocks = stocks;
          setState();
        },
        onError: (error) {
          _status = StocksLoadingStatus.error;
          setState();
        },
      );
    } catch (e) {
      _status = StocksLoadingStatus.error;
      setState();
    }
  }
}
