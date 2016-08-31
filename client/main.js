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
    zoom: 13,
    disableDefaultUI: true
  });

  var bikeLayer = new google.maps.BicyclingLayer();
  bikeLayer.setMap(map);

  createLocations();
}

function getColor(bikes){
  var value = Math.min(bikes / 6, 1);
  //value from 0 to 1
  var hue=((1-value)*120).toString(10);
  return ["hsl(",hue,",100%,50%)"].join("");
}

function createLocations(time) {
  data.forEach(function(obj) {
    var cityCircle = new google.maps.Circle({
      strokeColor: getColor(1),
      strokeOpacity: 0.8,
      strokeWeight: 2,
      fillColor: getColor(1),
      fillOpacity: 0.35,
      map: map,
      center: obj,
      radius: 300
    });

    var infoWindow = new google.maps.InfoWindow({
      content: obj.location_name + ' ' + obj.predictions[0].available_bikes,
      position: {lat: obj.lat, lng: obj.lng}
    });

    cityCircle.addListener('click', function() {
      infoWindow.open(map);
    });

    obj.circle = cityCircle;

  });
}

function render(time) {
  data.forEach(function(obj) {
    obj.circle.setOptions({strokeColor: getColor(obj.predictions[time].available_bikes), fillColor: getColor(obj.predictions[time].available_bikes)});
  });
}
