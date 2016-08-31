var map;

var data = [
  {lat: 60.165092, lng: 24.930971, location_name: 'Kaisaniemi', predictions: [{timestamp: 0, total_slots: 25, available_bikes: 5}, {timestamp: 1, total_slots: 25, available_bikes: 4}, {timestamp: 2, total_slots: 25, available_bikes: 2}]},
  {lat: 60.158126, lng: 24.945420, location_name: 'Ruoholahti', predictions: [{timestamp: 0, total_slots: 25, available_bikes: 7}, {timestamp: 1, total_slots: 25, available_bikes: 7}, {timestamp: 2, total_slots: 25, available_bikes: 0}]},
  {lat: 60.1699, lng: 24.9384,  location_name: 'Niemenmäki', predictions: [{timestamp: 0, total_slots: 25, available_bikes: 0}, {timestamp: 1, total_slots: 25, available_bikes: 1}, {timestamp: 2, total_slots: 25, available_bikes: 5}]}
];

document.querySelector('.slider').addEventListener('input', function(e) {
  var selectedTime = parseInt(this.value, 10);
  render(selectedTime);
});

function initMap() {
  map = new google.maps.Map(document.getElementById('map'), {
    center: {lat: 60.1699, lng: 24.9384},
    zoom: 14,
    disableDefaultUI: true
  });

  createLocations();
}

function getColor(bikes, maxBikes){
  var value = 1 - (bikes / maxBikes);
  //value from 0 to 1
  var hue = Math.round(((1-value)*120).toString(10));
  return ["hsl(",hue,",100%,50%)"].join("");
}

function createLocations(time) {
  json.forEach(function(obj) {
    var lat = parseFloat(obj.lat);
    var lng = parseFloat(obj.lon);
    var color = getColor(obj.avl_bikes_max, obj.total_slots);
    var cityCircle = new google.maps.Circle({
      strokeColor: color,
      strokeOpacity: 0.8,
      strokeWeight: 2,
      fillColor: color,
      fillOpacity: 0.35,
      map: map,
      center: {lat: lat, lng: lng},
      radius: 50
    });

    var infoWindow = new google.maps.InfoWindow({
      content: obj.name + ' ' + obj.avl_bikes_max + '/' + obj.total_slots,
      position: {lat: lat, lng: lng}
    });

    cityCircle.addListener('click', function() {
      infoWindow.open(map);
    });

    obj.circle = cityCircle;
    obj.info = infoWindow;

  });
}

function render(time) {
  data.forEach(function(obj) {
    obj.circle.setOptions({strokeColor: getColor(obj.predictions[time].available_bikes), fillColor: getColor(obj.predictions[time].available_bikes)});
    obj.info.setContent(obj.location_name + ' ' + obj.predictions[time].available_bikes);
  });
}
