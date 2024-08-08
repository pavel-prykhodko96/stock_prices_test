import 'package:flutter/material.dart';
import 'package:stock_prices/stock_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class StockChartTile extends StatefulWidget {
  final StockModel stock;

  const StockChartTile({required this.stock, super.key});

  @override
  State<StockChartTile> createState() => _StockChartTileState();
}

class _StockChartTileState extends State<StockChartTile> {
  late final double stockLow;
  late final double stockHigh;
  late final double difference;

  @override
  void initState() {
    stockLow = widget.stock.timeSeries
        .map((e) => e.low)
        .reduce((value, element) => value < element ? value : element);

    stockHigh = widget.stock.timeSeries
        .map((e) => e.high)
        .reduce((value, element) => value > element ? value : element);

    difference = stockHigh - stockLow;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SfCartesianChart(
          title: ChartTitle(text: widget.stock.metaData.symbol),
          primaryXAxis: const CategoryAxis(),
          primaryYAxis: NumericAxis(
            minimum: stockLow - difference / 10,
            maximum: stockHigh + difference / 10,
            interval: difference / 10,
          ),
          series: <CartesianSeries<TimeSeries, String>>[
            BoxAndWhiskerSeries<TimeSeries, String>(
              dataSource: widget.stock.timeSeries,
              xValueMapper: (TimeSeries data, index) => data.dateTime,
              yValueMapper: (TimeSeries data, index) => [
                data.open,
                data.low,
                data.high,
                data.close,
              ],
              pointColorMapper: (data, index) =>
                  data.open > data.close ? Colors.red : Colors.green,
            ),
          ],
        ),
      ],
    );
  }
}
