import 'dart:io';

import 'package:stock_prices/stocks_repository.dart';

class StockModel {
  final MetaData metaData;
  final List<TimeSeries> timeSeries;

  StockModel({
    required this.metaData,
    required this.timeSeries,
  });

  factory StockModel.fromJson(Map<String, dynamic> json) {
    final timeSeriesList = <TimeSeries>[];
    final timeSeriesMap =
        json['Time Series (${StockRepository.chosenInterval})']
            as Map<String, dynamic>?;
    timeSeriesMap?.forEach((key, value) {
      timeSeriesList.add(TimeSeries.fromEntity(key, value));
    });

    /* Solution for web, the chosen in repository for some reason leads to error in the web and no time to test:
      return StockModel(
        metaData: MetaData.fromJson(json['Meta Data']),
        timeSeries: timeSeriesList,
      );
    */

    // Works on iOs and Android, but not on web
    return StockModel(
      metaData: MetaData.fromJson(json['Meta Data']),
      timeSeries:
          ((Platform.isAndroid || Platform.isIOS) && timeSeriesList.length > 20)
              ? timeSeriesList.take(20).toList()
              : timeSeriesList,
    );
  }
}

class MetaData {
  final String information;
  final String symbol;
  final String lastRefreshed;
  final String interval;
  final String outputSize;
  final String timeZone;

  MetaData({
    required this.information,
    required this.symbol,
    required this.lastRefreshed,
    required this.interval,
    required this.outputSize,
    required this.timeZone,
  });

  factory MetaData.fromJson(Map<String, dynamic> json) {
    return MetaData(
      information: json['1. Information'],
      symbol: json['2. Symbol'],
      lastRefreshed: json['3. Last Refreshed'],
      interval: json['4. Interval'],
      outputSize: json['5. Output Size'],
      timeZone: json['6. Time Zone'],
    );
  }
}

class TimeSeries {
  final String dateTime;
  final double open;
  final double high;
  final double low;
  final double close;
  final double volume;

  TimeSeries({
    required this.dateTime,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.volume,
  });

  factory TimeSeries.fromEntity(String key, Map<String, dynamic> value) {
    return TimeSeries(
      dateTime: key,
      open: double.tryParse(value['1. open']) ?? 0,
      high: double.tryParse(value['2. high']) ?? 0,
      low: double.tryParse(value['3. low']) ?? 0,
      close: double.tryParse(value['4. close']) ?? 0,
      volume: double.tryParse(value['5. volume']) ?? 0,
    );
  }
}
