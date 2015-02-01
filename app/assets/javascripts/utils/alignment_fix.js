(function() {
  var Alignment = window.Alignment = function($el) {
    this.$el = $el;
  }

  Alignment.prototype.fix = function() {
    var max_height = 0;

    this.$el.children().each(function() {
      max_height = Math.max(max_height, $(this).height());
    });

    this.$el.children().css({ height: max_height })
  }
})()
