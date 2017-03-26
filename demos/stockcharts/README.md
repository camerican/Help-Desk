# Stock Quote Chart Example

The following example shows how we can use AM Charts with Yahoo! Finance data.  It utilizes the Sinatra web application libary (Ruby) to serve as a proxy to retrieve relevant data.  To take this example for a test drive, simply perform the following steps:

1. make sure Sinatra is installed via `bundle install` or `gem install sinatra`
2. start the server: `ruby server.rb`.
3. go to `http://localhost:4567` in your browser to view the sample application

## Using AM Charts

[AM Charts has various styles of charts available](https://www.amcharts.com/demos/) based upon source data we provide it.  For this example, we'll be adapting a sample chart from their stock charting example and supplying it with data from Yahoo Finance.

The JavaScript we use to build the chart is as follows:

```JavaScript
// adapted from the AMCharts guide to building a stockquote application:
var chart = AmCharts.makeChart( "chartdiv", {
  "type": "stock",
  "theme": "light",

  "dataSets": [ {
    "title": "<%= @stock %>",
    "fieldMappings": [ {
      "fromField": "Open",
      "toField": "open"
    }, {
      "fromField": "High",
      "toField": "high"
    }, {
      "fromField": "Low",
      "toField": "low"
    }, {
      "fromField": "Close",
      "toField": "close"
    }, {
      "fromField": "Volume",
      "toField": "volume"
    } ],
    "compared": false,
    "categoryField": "Date",

    /**
     * data loader for data set data
     */
    "dataLoader": {
      "url": "/stock/<%= @stock %>",
      "format": "csv",
      "showCurtain": true,
      "showErrors": true,
      "async": true,
      "reverse": true,
      "delimiter": ",",
      "useColumnNames": true
    },
  } ]
 } );
```

Notice that we're using `erb` to dynamically reference the stock we're interested in; the instance variable `@stock` will need to be set by the controller (Rails) or route handling block (Sinatra).  To make sure that the embeddable Ruby within this JavaScript gets processed, we'll want to either name our file with the extension `.js.erb` (Rails will process `erb` files within `app/assets/javascripts`) or we can simply put the JavaScript directly within `script` tags in our `erb` view.

## Requesting Data From Yahoo Finance

AM Charts provides us the ability to specify a url to load data via the dataLoader plugin.  We can retrieve data from Yahoo Finance directly by making a request to chart.finance.yahoo.com/table.csv while passing in the relevant query string parameters:

* s - stock symbol to look up
* a - start month
* b - start day
* c - start year
* d - end month
* e - end day
* f - end year
* g - d (daily), m (monthly), y (yearly)

This means we should be able to make the following request to load data on 3M from 6/1/16 - 3/25/17:

```JavaScript
    "dataLoader": {
      "url": "http://chart.finance.yahoo.com/table.csv?s=MMM&a=6&b=1&c=2016&d=3&e=25&f=2017&g=d&ignore=.csv",
      "format": "csv",
      "showCurtain": true,
      "showErrors": true,
      "async": true,
      "reverse": true,
      "delimiter": ",",
      "useColumnNames": true
    },

```

Unfortunately, we'll get back an error message: `No Access-Control-Allow-Origin header is present on the requested resource.`  This is because Yahoo is not providing headers that explicitly instruct that we're allowed to access this data and our browser is respecting that request by throwing a CORS error.

### CORS Problems

By making this request to Yahoo for data, we run into Cross-Origin Resource Sharing issues.  DataLoader is not requesting the data in a manner that allows the request.  While this should in theory be correctable and DataLoader *claims* that it is able to set headers via a key that references an array of objects that in turn hold the headers to use for our request, this approach was not successful in my tests.

To correct this, we could:

1) use an intermediary via Yahoo Query Language, which could serve as an intermediary:

[http://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.historicaldata%20where%20symbol%20%3D %20%22YHOO%22%20and%20startDate%20%3D%20%222009-09-11%22%20and %20endDate%20%3D%20%222010-03-10%22&diagnostics=true&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys](http://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.historicaldata%20where%20symbol%20%3D %20%22YHOO%22%20and%20startDate%20%3D%20%222009-09-11%22%20and %20endDate%20%3D%20%222010-03-10%22&diagnostics=true&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys)

2) we could make an valid CORS request (see references)

3) we could leverage Ruby's application server to be a proxy between our JavaScript request and the Yahoo data.  

Our example takes option #3 and uses Sinatra for simplicity.  Within our Sinatra application, the main route retrieves the stock from the URL and ensures it's properly formatted in uppercase letters:


```
get '/' do
  @stock = params[:s] && params[:s].length > 0 ? @params[:s].upcase : nil
  erb :home
end
```

Then from within our JavaScript, when we call the DataLoader we're going to request a particular stock from a route on our own application server.

```erb
"url": "/stock/<%= @stock %>"
```

We'll set up a route to handle this request and capture the requested stock: `get '/stock/:stock'`. Whatever the stock is, we will retrieve the data from Yahoo Finance and then return it back to the requesting page.  Here's how the route that serves as a middle-man to get around the CORS issue looks:

```ruby
get '/stock/:stock' do
  @stock = params[:stock].upcase
  halt 500 unless @stock && @stock.length > 0
  content_type :csv
  uri = URI( 'http://chart.finance.yahoo.com/table.csv' )
  uri.query = URI.encode_www_form(
    s: @stock,        # s - stock symbol to look up
    a: 6,             # a - start month
    b: 1,             # b - start day
    c: 2016,          # c - start year
    d: 3,             # d - end month
    e: 30,            # e - end day
    f: 2017,          # f - end year
    g: 'd',           # g - d (daily), m (monthly), y (yearly)
    ignore: '.csv'
  )
  Net::HTTP.get_response( uri ).body
end
```

And that's it!  We now have all the ingredients for displaying Yahoo Finance data with AM Charts.  We could also add in extra fields to customize the date range very easily.  

Enjoy!

---

References:
* [Hooking up AM Charts to Data Feed Servies](https://www.amcharts.com/kbase/hooking-chart-data-feed-services/)
* [Using AM Charts DataLoader Plugin](https://www.amcharts.com/kbase/using-data-loader-plugin/)
* [Using YQL to Retrieve Stock Quotes](http://www.yqlblog.net/blog/2009/06/02/getting-stock-information-with-yql-and-open-data-tables/)
* [CloudQuote API](https://www.cloudquote.net/products/api), suggested by AM Charts
* [HTTP Access Control](https://developer.mozilla.org/en-US/docs/Web/HTTP/Access_control_CORS)
* [Stack Overflow Example](http://stackoverflow.com/questions/6567119/yahoo-jsonp-ajax-request-wrapped-in-callback-function)
* [Using CORS](https://www.html5rocks.com/en/tutorials/cors/)
* [Understanding and Using CORS](http://restlet.com/company/blog/2015/12/15/understanding-and-using-cors/)