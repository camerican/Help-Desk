# Cocktail DB API Example

In this example, we'll be providing a form for submitting search results to the Cocktail DB API.

## Options

There are two primary options for displaying results:

* Client-side request for the API data
* Server-side request for the API data [our example]
 
While we could go with either approach, this example demonstrates the server response.  One advantage to this is that it gets around CORS issues without having to do any header configuration.  It would also allow us to more easily store data to a database as we have access to the results on the server side.

This example does not use any database nor were any CORS issues detected, so there's no overwhelming advantage for using a server-side approach.  

The client side approach would involve making an asynchronous request from within our html page via JavaScript.  We could use a vanilla JavaScript approach (via XMLHttpRequest or other means), using jQuery's `$.ajax` method, using `axios`, or using the fetch API.  We would then have to process the response and update the page, which we could do either manually or via a front-end framework.  The one advantage to this approach would be updating the page without forcing a refresh.

## User Flow

* User submits an ingredient via form
* A request is sent out to thecocktaildb.com and processed for rendering in the view
* The view shows the results, if there are any [Repeat]

## Response Data

The data that the cocktail database returns is an array nested within an object, under a "drinks" key.  We extract this data and convert it into a ruby hash via `JSON.parse` and then send along the array as an instance varaible that the view can process.

Within the view, we then iterate over the `@results` and display each drink in the list.
