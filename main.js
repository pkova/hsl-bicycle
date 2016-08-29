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
    {lat: 60.165092, lng: 24.930971, color: '#FF0000'},
    {lat: 60.158126, lng: 24.945420, color: '#00FF00'},
    {lat: 60.1699, lng: 24.9384, color: '#00FF00'}
  ];

  coords.forEach(function(coord) {
    var cityCircle = new google.maps.Circle({
      strokeColor: coord.color,
      strokeOpacity: 0.8,
      strokeWeight: 2,
      fillColor: coord.color,
      fillOpacity: 0.35,
      map: map,
      center: coord,
      radius: 300
    });
  });
}


