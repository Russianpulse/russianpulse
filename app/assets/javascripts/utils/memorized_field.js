(function() {
  MemorizedField = function($el) {
    this.$el = $el;

    this.restoreValue();

    var self = this;
    this.$el.closest("form").on("submit", function() {
      self.saveValue();
    });


  }

  MemorizedField.prototype.restoreValue = function() {
    var previousValue = Cookies("MemorizedField_" + this.$el.attr("id"));
    this.$el.val(previousValue);
  }

  MemorizedField.prototype.saveValue = function() {
    Cookies("MemorizedField_" + this.$el.attr("id"), this.$el.val(), { path: "/", expires: 3 * 365 });
  }


  window.MemorizedField = MemorizedField;
})()
