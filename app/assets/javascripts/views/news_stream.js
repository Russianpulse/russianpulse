//= require ./news_item

(function() {
  var NewsItem = Views.NewsItem;

  var NewsStream = Backbone.View.extend({
    template: JST["templates/news_stream"],

    initialize: function() {
      this.count = 0;

      setInterval(_.bind(function() {
        this.updateCounter();
      }, this), 10000);
    },

    render: function() {
      var that = this;

      this.$el.html(this.template({ title: this.title, count: this.count }));
      this.updateCounter();

      this.collection.each(function(item) {
        var view = new NewsItem({ model: item });
        var $el = view.render().data("view", view)

        that.$(".news-stream__list").append(view.render())
      })

      this.trigger("render");
      return this.$el;
    },

    activateDragAndDrop: function(lists) {
      var that = this;

      this.$(".news-stream__list").sortable({
        connectWith: lists,
        receive: function(ev, ui) {
          that.acceptNewItem(ui.item.data("view").model);
          that.count++;
          that.renderCounter();
        },
        remove: function(ev, ui) {
          that.count--;
          that.renderCounter();
        }
      }).disableSelection();
    },

    acceptNewItem: function(model) {
      model.collection.remove(model);
      this.collection.add(model);
      model.setStream(this.stream);
    },

    updateCounter: function() {
      var that = this;

      return $.ajax("/admin/dashboard/stream_count/"+this.stream, {
        method: "GET",
        cache: false
      }).done(function(data) {
        that.count = data.count;
        that.renderCounter();
      });
    },

    renderCounter: function() {
      this.$(".news-stream__counter").html(this.count);
    }
  })

  window.Views.NewsStream = NewsStream;
})();
