// Import the Pebble JS library
var UI = require('ui');
var Vector2 = require('vector2');

// Show startup information
console.log('PebbleKit JS starting!');

// Set callback for when the app is ready
Pebble.addEventListener('ready', function(e) {
  console.log('PebbleKit JS ready!');
  
  // Get the watch's location for weather display
  navigator.geolocation.getCurrentPosition(function(pos) {
    var coordinates = pos.coords;
    fetchWeather(coordinates.latitude, coordinates.longitude);
  }, function(err) {
    console.log('Error getting location: ' + err.message);
  });
});

// Function to fetch weather data
function fetchWeather(latitude, longitude) {
  var url = 'https://api.openweathermap.org/data/2.5/weather' +
    '?lat=' + latitude + '&lon=' + longitude + '&units=metric';
  
  // This is a demo so no API key is included - in a real app you would add your API key
  
  console.log('Weather URL: ' + url);
  console.log('Would fetch weather here in a real app');
  
  // In a real app, you would do an API call:
  // var req = new XMLHttpRequest();
  // req.open('GET', url, true);
  // req.onload = function() { ... }
  // req.send();
  
  // For the demo, just send sample data to the watch
  var tempData = {
    temperature: 22,
    conditions: 'Sunny'
  };
  
  sendWeatherToWatch(tempData);
}

// Function to send data to the watch
function sendWeatherToWatch(data) {
  console.log('Sending weather data to watch: ' + JSON.stringify(data));
  
  Pebble.sendAppMessage(
    {
      'TEMPERATURE': data.temperature,
      'CONDITIONS': data.conditions
    },
    function(e) {
      console.log('Weather info sent successfully!');
    },
    function(e) {
      console.log('Error sending weather info to Pebble!');
    }
  );
} 