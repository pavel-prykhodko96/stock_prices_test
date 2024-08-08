# stock_prices

Flutter version 3.22.3

- You need to run 'flutter pub get' in the terminal in the projects directory
- You need API key from: https://www.alphavantage.co/support/#api-key -> then replace it in lib/stocks_repository.dart file, 5 row, youApiKey variable.
- The current solution works on Android and iOS. For the web, there is a strange bug and I have no time to dive into it, so if you want to test it on the web: go to lib/stock_model.dart -> uncomment solution from 24 - 27 rows -> comment solution on 31 - 37 rows.
