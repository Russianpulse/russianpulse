(function() {
  var Markers = function() {
  }

  Markers.prototype.markUser = function(marker, value) {
    Cookies("permament_user_marker_" + marker, value, { path: "/", expires: 3 * 365 });
  }

  Markers.prototype.markUserOnce = function(marker, value, func) {
    if(this.getUserMarker(marker) == undefined) {
      this.markUser(marker, value, func);
    }
  }
  
  Markers.prototype.getUserMarker = function(marker, func) {
    return Cookies("permament_user_marker_" + marker);
  }

  Markers.prototype.counterIncrement = function(name) {
    this.markUserOnce("counter_" + name, 0);
    this.markUser("counter_" + name, parseInt(this.getUserMarker("counter_" + name)) + 1);
  }

  Markers.prototype.getCounter = function(name) {
    return parseInt(this.getUserMarker("counter_" + name));
  }

  window.mrk = new Markers();
})()

