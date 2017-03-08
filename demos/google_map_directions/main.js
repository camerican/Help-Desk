var directionsDisplay;
var directionsService = new google.maps.DirectionsService();
var map;

function initialize() {
  directionsDisplay = new google.maps.DirectionsRenderer();
  map = new google.maps.Map(document.getElementById('map'));
  directionsDisplay.setMap(map);
}

function calcRoute() {
  var start = document.getElementById('origin').value;
  var end = document.getElementById('destination').value;
  var mode = document.getElementById('mode').value;
  var request = {
    origin: start,
    destination: end,
    travelMode: mode
  };
  directionsService.route(request, function(result, status) {
    if (status == 'OK') {
      directionsDisplay.setDirections(result);
    }
  });
}
document.addEventListener("DOMContentLoaded",function(){
  initialize();
  calcRoute();
  document.getElementById("search").addEventListener("submit",function(event){
    event.preventDefault();
    calcRoute();
  });
});