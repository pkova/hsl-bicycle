var map;

document.querySelector('.slider').addEventListener('input', function(e) {
  var selectedTime = parseInt(this.value, 10);
  render(selectedTime);
});

// Initalize slider
var time = new Date();
// var currentHour = time.getHours();
var currentHour = 0;
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

function getRealColor(bikes, maxBikes){
  var value = 1 - (bikes / maxBikes);
  //value from 0 to 1
  var hue = Math.round(((1-value)*120).toString(10));
  return ["hsl(",hue,",100%,50%)"].join("");
}

function getPredictColor(likelihood){
  var value = likelihood / 0.3;
  //value from 0 to 1
  var hue = Math.round(((1-value)*120).toString(10));
  return ["hsl(",hue,",100%,50%)"].join("");
}

function roundToDecimals(num) {
  var str = num.toString();
  return parseFloat(str.substr(0, str.indexOf('.') + 3));
}

function createLocations(time) {
  json.forEach(function(obj) {
    var lat = parseFloat(obj.lat);
    var lng = parseFloat(obj.lon);
    var cityCircle = new google.maps.Circle({
      strokeColor: getPredictColor(obj.predictions[0].likelihood + 0.05),
      strokeOpacity: 0.8,
      strokeWeight: 2,
      fillColor: getPredictColor(obj.predictions[0].likelihood),
      fillOpacity: 0.35,
      map: map,
      center: {lat: lat, lng: lng},
      radius: 50
    });

    var content = document.createElement('div');

    var placeName = document.createElement('div');
    placeName.innerText = obj.name;
    content.appendChild(placeName);

    var odds = document.createElement('div');
    odds.innerText = roundToDecimals(obj.predictions[0].likelihood) + ' % klo 00';
    content.appendChild(odds);

    obj.odds = odds;

    var canvas = document.createElement('canvas');
    canvas.width = 350;
    canvas.height = 150;

    var context = canvas.getContext('2d');

    context.fillStyle = '#000000';

    context.beginPath();
    context.moveTo(24, 0);
    context.lineTo(24, 150);
    context.stroke();

    context.beginPath();
    context.moveTo(13, 130);
    context.lineTo(400, 130);
    context.stroke();

    context.font = '10px Helvetica, sans-serif';

    context.fillText('0.3', 0, 33);
    context.strokeText('0.3', 0, 33);
    context.fillText('0.2', 0, 66);
    context.strokeText('0.2', 0, 66);
    context.fillText('0.1', 0, 99);
    context.strokeText('0.1', 0, 99);
    context.fillText('0', 0, 135);
    context.strokeText('0', 0, 135);

    context.fillText('00', 32, 140);
    context.strokeText('00', 32, 140);
    context.fillText('01', 50, 140);
    context.strokeText('01', 50, 140);
    context.fillText('02', 67, 140);
    context.strokeText('02', 67, 140);
    context.fillText('03', 84, 140);
    context.strokeText('03', 84, 140);
    context.fillText('04', 101, 140);
    context.strokeText('04', 101, 140);
    context.fillText('05', 117, 140);
    context.strokeText('05', 117, 140);
    context.fillText('06', 134, 140);
    context.strokeText('06', 134, 140);
    context.fillText('07', 152, 140);
    context.strokeText('07', 152, 140);
    context.fillText('08', 169, 140);
    context.strokeText('08', 169, 140);
    context.fillText('09', 186, 140);
    context.strokeText('09', 186, 140);
    context.fillText('10', 202, 140);
    context.strokeText('10', 202, 140);
    context.fillText('11', 220, 140);
    context.strokeText('11', 220, 140);
    context.fillText('12', 236, 140);
    context.strokeText('12', 236, 140);
    context.fillText('13', 253, 140);
    context.strokeText('13', 253, 140);
    context.fillText('14', 270, 140);
    context.strokeText('14', 270, 140);
    context.fillText('15', 287, 140);
    context.strokeText('15', 287, 140);
    context.fillText('16', 305, 140);
    context.strokeText('16', 305, 140);
    context.fillText('17', 321, 140);
    context.strokeText('17', 321, 140);


    obj.predictions.forEach(function(prediction, i) {
      context.fillStyle = '#'+Math.floor(Math.random()*16777215).toString(16);
      context.fillRect((i * 17) + 45, 125, -14, -prediction.likelihood * 300);
    });

    content.appendChild(canvas);

    var infoWindow = new google.maps.InfoWindow({
      content: content,
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
  // if (time === 0) {
  //   json.forEach(function(obj) {
  //     var color = getRealColor(obj.avl_bikes_max, obj.total_slots);
  //     obj.circle.setOptions({
  //       strokeColor: color,
  //       fillColor: color,
  //       strokeOpacity: 0.8,
  //       strokeWeight: 2,
  //       fillOpacity: 0.35
  //     });
  //     obj.info.setContent(obj.name + ' ' + obj.avl_bikes_max + '/' + obj.total_slots);
  //   });
  // } else {
    json.forEach(function(obj) {
      obj.circle.setOptions({
        strokeColor: getPredictColor(obj.predictions[time].likelihood + 0.05),
        fillColor: getPredictColor(obj.predictions[time].likelihood),
        strokeOpacity: 0.8,
        strokeWeight: 2,
        fillOpacity: 0.35
      });
      obj.odds.innerText = roundToDecimals(obj.predictions[time].likelihood) + ' % klo' + ' ' + time;
    });
  // }

}

