(function() {
  var NewsItem = Backbone.View.extend({
    template: JST["templates/news_item"],

    render: function() {
      this.$el.html(this.template({ item: this.model }));

      return this.$el;
    },
  })

  window.Views.NewsItem = NewsItem;
})();
