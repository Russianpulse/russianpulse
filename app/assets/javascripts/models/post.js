(function() {
  var Post = Backbone.Model.extend({
    createdAt: function() {
      return new Date(Date.parse(this.get("created_at")));
    },
    setStream: function(stream) {
      return $.ajax("/dashboard/update_post", {
        data: {
          id: this.get("id"),
          post: { stream: stream },
        },
        method: "PUT",
      })
    },
    url: function() {
      return "/posts/" + this.get("id");
    }
  });

  Models.Post = Post;
})();
