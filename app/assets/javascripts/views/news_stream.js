//= require ./news_item

(function() {
  var NewsItem = Views.NewsItem;

  var NewsStream = Backbone.View.extend({
    template: JST["templates/news_stream"],

    render: function() {
      var that = this;

      this.$el.html(this.template({ title: this.title }));

      this.collection.each(function(item) {
        var view = new NewsItem({ model: item });
        var $el = view.render().data("view", view)

        that.$(".news-stream__list").append(view.render())
      })

      this.trigger("render");
      return this.$el;
    },

    activateDragAndDrop: function(lists) {
      var self = this;

      this.$(".news-stream__list").sortable({
        connectWith: lists,
        receive: function(ev, ui) {
          self.acceptNewItem(ui.item.data("view").model);
        }
      }).disableSelection();
    },

    acceptNewItem: function(model) {
      model.collection.remove(model);
      this.collection.add(model);
      //this.render();
      model.setStream(this.stream);
    }
  })

  window.Views.NewsStream = NewsStream;
})();
