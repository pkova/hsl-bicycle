var map;
var circles = [];

var data = [
  {lat: 60.165092, lng: 24.930971, total_slots: 20, available_bikes: 1, location_name: 'Kaisaniemi', time: 2},
  {lat: 60.158126, lng: 24.945420, total_slots: 15, available_bikes: 3, location_name: 'Ruoholahti', time: 1},
  {lat: 60.1699, lng: 24.9384, total_slots: 25, available_bikes: 0, location_name: 'Niemenmäki', time: 0}
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

function getColor(value){
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
      content: obj.location_name,
      position: {lat: obj.lat, lng: obj.lng}
    });

    cityCircle.addListener('click', function() {
      infoWindow.open(map);
    });

    circles.push({circle: cityCircle, info: infoWindow});
  });
}

function render(time) {
}
