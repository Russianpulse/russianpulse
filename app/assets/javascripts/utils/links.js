(function() {
  var links = window.links = function() {}

  var domainRe = /https?:\/\/((?:[\w\d-.]+\.)+[\w\d]{2,})/i;

  var domain = links.domain = function(url) {
    var match = domainRe.exec(url);

    if(match != null) {
      return match[1];  
    }
  }

  var is_external = links.is_external = function(url) {
    if(domain(url) != undefined) {
      return domain(location.href) !== domain(url);
    } else {
      return false
    }
  }

  var cut_after_hash = links.cut_after_hash = function(url) {
    return url.split("#")[0];
  }

  var add_param = links.add_param = function(url, param, value) {
    url = cut_after_hash(url);

    return url + (url.indexOf('?') != -1 ? "&" : "?") + param + "=" + value;
  }

  var add_params = links.add_params = function(url, params) {
    var result = url;

    for(name in params) {
      result = add_param(result, name, params[name]);
    }

    return result;
  }
})();
