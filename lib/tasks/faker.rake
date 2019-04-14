namespace :faker do
  desc 'Fake db data'
  task database: :environment do
    [Post, Tag, Blog, Comment, User].each(&:delete_all)

    100.times do |_n|
      User.create! name: Faker::Name.name, email: Faker::Internet.email, password: 'secret123', password_confirmation: 'secret123'
    end

    50.times do |_n|
      Tag.create title: Faker::Lorem.word
    end

    50.times do |n|
      Blog.create title: Faker::Book.title, slug: "blog-#{n}", featured: n == 1
    end

    Blog.find_each do |b|
      (1000 / 50).times do |_n|
        body = (0..10).to_a.map { "<p>#{Faker::Lorem.paragraph}</p>" }.join

        post = Post.create!(title: Faker::Lorem.sentence, blog: b, body: body, top: rand(100) > 80)

        post_tags = (0..rand(10)).to_a.map { Tag.all.sample }
        post.tags_list = post_tags.map(&:title).join(', ')
        post.save

        post_tags.each { |t| t.post_ids << post.id }

        post.comments.create! comment: Faker::Lorem.sentence, user: User.all.sample if rand(100) > 80

        print '.'

        print Post.count if rand(100) > 97
      end
    end

    tags.each(&:save)
  end
end
