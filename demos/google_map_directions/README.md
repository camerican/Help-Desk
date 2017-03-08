# Google Maps API for Directions

This is a demonstration of the Google Maps API for providing directions between two points.  We have inputs for an origin, destination, and mode of transport which we pass along to the API to render a map.

![](../assets/google_map_directions.png)

## Getting Started

### Include the Google Maps API JavaScript File

First, include the Google Maps JavaScript file in your document with your API key encoded in the query string:

`https://maps.googleapis.com/maps/api/js?key=YOURAPIKEYHERE`

For this example, we want to make certain that we're not invoking a callback function in the query string.

Make certain you have a container tag in your html to hold your map and give it appropriate dimensions via css.  In this example, we'll be placing the map in a div with an id of `map` and sizing it to be 600px by 400px.

We've configured a basic form for providing the origin, destination, and mode of transport to the API for drawing on our map.  This data is processed through the `calcRoute` function.

The other function of note id `initialize`, which we want to invoke after the page has loaded.  After the `DOMContentLoaded` event fires, we perform the following actions:

1. call initialize() - this sets up the map for us
1. call calcRoute() - this gets initial directions up
1. attach a `submit` listener to the form so that we update the route whenever we submit

The submit listener will prevent the form from submitting and then recalculate the route.


