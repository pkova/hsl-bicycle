var map;

document.querySelector('.slider').addEventListener('input', function(e) {
  var selectedTime = parseInt(this.value, 10);
  render(selectedTime);
});

// Initalize slider
var time = new Date();
var currentHour = time.getHours();
var originalTime = currentHour;

var times = Array.prototype.slice.call(document.querySelectorAll('.timescontainer > div'));

times.forEach(function(time, i) {
  var text = currentHour + i;
  if (text.toString().length === 1) {
    text = '0' + text;
  }
  time.innerText = text;
  if (currentHour + i === 23) {
    currentHour = -(24 - originalTime);
  }
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
