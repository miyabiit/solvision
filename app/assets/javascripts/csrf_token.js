window.getCsrfToken = function() {
  var metaTags = document.getElementsByTagName("meta")
  for (var i = 0; i < metaTags.length; ++i) {
    var elem = metaTags[i]
    if (elem.name === "csrf-token") {
      return elem.content
    }
  }
}
