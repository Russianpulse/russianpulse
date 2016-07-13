//= require ./news_stream
//= require ../models/post

(function() {
  var NewsStream = Views.NewsStream;

  var PostsCollection = Backbone.Collection.extend({
    model: Models.Post,
  })

  var NewsDashboard = Backbone.View.extend({
    STREAMS:  [
      { title: "Trash", key: "trash"},
      { title: "Inbox", key: "inbox"},
      { title: "Pulse", key: "pulse"}
    ],

    initialize: function() {
      this.initialize_streams()
    },

    initialize_streams: function() {
      var that = this;

      this.streams = [];

      _.each(this.STREAMS, function(stream_params) {
        var collection = new PostsCollection(gon.posts[stream_params.key]);

        var stream = new NewsStream({ collection: collection });
        stream.stream = stream_params.key;
        stream.title = stream_params.title;

        that.streams.push(stream)
      })
    },

    template: JST["templates/news_dashboard"],
    
    render: function() {
      var that = this;

      this.$el.html(this.template());

      this.activateDragAndDrop();
      _.each(this.streams, function(stream) {
        stream.$el = that.$(".news-dashboard__" + stream.stream);
        stream.render();
      })

      return this.$el
    },

    activateDragAndDrop: function() {
      var that = this;

      _.each(this.streams, function(stream) {
        stream.on("render", function() {
          _.each(that.streams, function(stream) {
            stream.activateDragAndDrop(that.$('.news-stream__list'));
          });
        })
      });
    },
  });

  window.Views.NewsDashboard = NewsDashboard;
})()
