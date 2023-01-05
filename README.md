# hledger-prices

CLI utility to obtain given stock prices and currency exchange rates from the [Alpha Vantage API](https://www.alphavantage.co/documentation/), and print them out in [hledger's price format](https://hledger.org/1.28/hledger.html#declaring-market-prices).

## Usage

```sh
hledger-prices --alphavantage-key $ALPHA_VANTAGE_KEY --base-currency SGD --currencies USD,ETH --stocks VT,GOOG --delay 15
```

This command will get the most recent exchange rates between SGD/USD and SGD/ETH and stock prices of VT and GOOG.

Note:
- only the most recent records are fetched.
- the following APIs are used: [stock latest price](https://www.alphavantage.co/documentation/#latestprice) and [currency exchange](https://www.alphavantage.co/documentation/#currency-exchange).
- the free Alpha Vantage API only allows 5 requests per minute, so you might want to add a delay between requests.