# ISBNdb Demo with AJAX and Sinatra

In this demonstration we're making a request to the ISBNdb site to retrive books for a given search.  We POST to our root route which in turn makes a net/http request for json data.  We then pass this data back along to the requesting AJAX call, captured by the `success` handler.

The demo is simply updating the results with a series of list items.  This could be adapted to be output