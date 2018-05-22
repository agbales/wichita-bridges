const locations = bridge_data.map(function(b) {
  var mapEntry = [];
  var info = "<b>Built In: </b>" + b.year_build + "<br>" +
             "<b>Span Length: </b>" + b.span_length + " ft<br>" +
             "<b>Total Length: </b>" + b.total_length + " ft<br>" +
             "<b>Condition: </b>" + b.considtion + "<br>" +
             "<b>Design: </b>" + b.design + "<br>";
  mapEntry.push(
    info,
    b.latitude,
    b.longitude,
    b.id
  )
  return mapEntry;
});

var map = new google.maps.Map(document.getElementById('map'), {
  zoom: 12,
  center: new google.maps.LatLng(37.697948, -97.314835),
  mapTypeId: google.maps.MapTypeId.ROADMAP
});

var infowindow = new google.maps.InfoWindow();

var marker, i;

for (i = 0; i < locations.length; i++) {  
  marker = new google.maps.Marker({
    position: new google.maps.LatLng(locations[i][1], locations[i][2]),
    map: map
  });

  google.maps.event.addListener(marker, 'click', (function(marker, i) {
    return function() {
      infowindow.setContent(locations[i][0]);
      infowindow.open(map, marker);
    }
  })(marker, i));
}