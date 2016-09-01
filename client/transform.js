var c = _.map(a, function(obj) {
  var result = obj;
  var predictions = _.filter(b, function(e) {
    return e.station === obj.name.substr(0, 3);
  });
  result.predictions = predictions;
  return result;
});
