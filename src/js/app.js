// Simple JavaScript companion for Hello World app
Pebble.addEventListener('ready', function() {
  console.log('PebbleKit JS ready!');
});

Pebble.addEventListener('appmessage', function(e) {
  console.log('AppMessage received!');
}); 