def fake_word
  (0..3 + rand(10)).to_a.map { ('a'..'z').to_a.sample }.join
end

def fake_sentance
  (0..3 + rand(10)).to_a.map { fake_word }.join(' ') + '.'
end

def fake_paragraph
  (0..3 + rand(10)).to_a.map { fake_sentance }.join(' ')
end

namespace :faker do
  desc 'Fake db data'
  task database: :environment do
    [Post, Tag, Blog].each(&:delete_all)

    50.times do |_n|
      Tag.create! title: fake_word
    end

    tags = Tag.all

    50.times do |n|
      Blog.create! title: fake_word, slug: "blog-#{n}", featured: n == 1
    end

    Blog.find_each do |b|
      (10_000 / 50).times do |_n|
        body = (0..10).to_a.map { "<p>#{fake_paragraph}</p>" }.join

        post = Post.create!(title: fake_sentance, blog: b, body: body, top: rand(100) > 80)

        post_tags = (0..rand(10)).to_a.map { tags.sample }
        post.tags_list = post_tags.map(&:title).join(', ')
        post.save

        post_tags.each { |t| t.post_ids << post.id }

        print '.'

        print Post.count if rand(100) > 97
      end
    end

    tags.each(&:save)
  end
end
