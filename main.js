var map;
function initMap() {
  map = new google.maps.Map(document.getElementById('map'), {
    center: {lat: 60.1699, lng: 24.9384},
    zoom: 13,
    disableDefaultUI: true
  });

  var bikeLayer = new google.maps.BicyclingLayer();
  bikeLayer.setMap(map);
  var coords = [
    {lat: 60.165092, lng: 24.930971, weight: 0.8},
    {lat: 60.158126, lng: 24.945420, weight: 0.5},
    {lat: 60.1699, lng: 24.9384, weight: 0.1}
  ];

  coords.forEach(function(coord) {
    var cityCircle = new google.maps.Circle({
      strokeColor: getColor(coord.weight),
      strokeOpacity: 0.8,
      strokeWeight: 2,
      fillColor: getColor(coord.weight),
      fillOpacity: 0.35,
      map: map,
      center: coord,
      radius: 300
    });
  });
}

function getColor(value){
  //value from 0 to 1
  var hue=((1-value)*120).toString(10);
  return ["hsl(",hue,",100%,50%)"].join("");
}
