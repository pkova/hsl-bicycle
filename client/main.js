var map;

var coords = [
  {lat: 60.165092, lng: 24.930971, total_slots: 20, available_bikes: 1, location_name: 'Kaisaniemi'},
  {lat: 60.158126, lng: 24.945420, total_slots: 15, available_bikes: 3, location_name: 'Ruoholahti'},
  {lat: 60.1699, lng: 24.9384, total_slots: 25, available_bikes: 0, location_name: 'Niemenmäki'}
];

function initMap() {
  map = new google.maps.Map(document.getElementById('map'), {
    center: {lat: 60.1699, lng: 24.9384},
    zoom: 13,
    disableDefaultUI: true
  });

  var bikeLayer = new google.maps.BicyclingLayer();
  bikeLayer.setMap(map);

  render();
}

function getColor(value){
  //value from 0 to 1
  var hue=((1-value)*120).toString(10);
  return ["hsl(",hue,",100%,50%)"].join("");
}

function render() {
  coords.forEach(function(coord) {
    var cityCircle = new google.maps.Circle({
      strokeColor: getColor(1),
      strokeOpacity: 0.8,
      strokeWeight: 2,
      fillColor: getColor(1),
      fillOpacity: 0.35,
      map: map,
      center: coord,
      radius: 300
    });

    var infoWindow = new google.maps.InfoWindow({
      content: coord.location_name,
      position: {lat: coord.lat, lng: coord.lng}
    });

    cityCircle.addListener('click', function() {
      infoWindow.open(map);
    });
  });
}
