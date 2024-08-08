import 'package:flutter/material.dart';
import 'package:june/june.dart';
import 'package:stock_prices/stock_chart_tile.dart';
import 'package:stock_prices/stocks_june_state.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: JuneBuilder(
        () => StocksJuneState(),
        builder: (state) {
          final Widget scafffoldHomeWidget;

          switch (state.status) {
            case StocksLoadingStatus.loading:
              scafffoldHomeWidget =
                  const Center(child: CircularProgressIndicator());
            case StocksLoadingStatus.done:
              scafffoldHomeWidget = ListView.builder(
                itemCount: state.stocks.length,
                itemBuilder: (context, index) {
                  final stock = state.stocks[index];

                  return StockChartTile(stock: stock);
                },
              );
            case StocksLoadingStatus.error:
              scafffoldHomeWidget = const Center(
                  child: Text(
                      '''Error during loading, check is API key valid, did you reach its limitations.\n'''
                      '''You can try again with refresh button or restart the app with fixed API key.'''));
          }
          return Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                state.fetchStocks();
              },
              child: const Icon(Icons.refresh),
            ),
            body: scafffoldHomeWidget,
          );
        },
      ),
    );
  }
}
