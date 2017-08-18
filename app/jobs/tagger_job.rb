class TaggerJob < ApplicationJob
  queue_as :default

  class WordsCollection
    def initialize(text)
      @stemmer_en = Lingua::Stemmer.new(language: :en)
      @text_en = text.mb_chars.downcase.remove(/[а-я]+/)
      @words_en = @text_en.split(/[^[:alnum:]]+/).uniq.compact.map do |w|
        @stemmer_en.stem w
      end.uniq.compact
      @stemmed_text_en = @words_en.join(' ')

      @stemmer_ru = Lingua::Stemmer.new(language: :ru)
      @text_ru = text.mb_chars.downcase.remove(/[a-z]+/)
      @words_ru = @text_ru.split(/[^[:alnum:]]+/).uniq.compact.map do |w|
        @stemmer_ru.stem w
      end.uniq.compact
      @stemmed_text_ru = @words_ru.join(' ')
    end

    def match_tag?(tag)
      result = nil

      stemmer = stemmed_text = words = nil
      if tag.russian?
        stemmer = @stemmer_ru
        stemmed_text = @stemmed_text_ru
        words = @words_ru
      else
        stemmer = @stemmer_en
        stemmed_text = @stemmed_text_en
        words = @words_en
      end

      tag_aliases = tag.self_and_aliases.map do |w|
        tag_words = w.split(/[^[:alnum:]]+/)

        if tag_words.size > 1
          stemmed_tag = tag_words.map { |w| stemmer.stem(w).mb_chars.downcase.to_s }.join(' ')

          if stemmed_text.include?(stemmed_tag)
            result = true
            break
          end
        else
          stemmed_tag = stemmer.stem(w).mb_chars.downcase.to_s

          if words.include? stemmed_tag
            result = true
            break
          end
        end
      end

      result
    end
  end

  def perform(post)
    text = post.title + ' ' + post.body

    # разбиваем текст на блоки по 300 слов, чтобы не занимать много памяти
    tags = text.split(/[^[:alnum:]]+/).in_groups_of(300, false).map do |words|
      match_tags(words.join(' '))
    end.flatten.uniq

    apply_tags(post, tags)
  end

  private

  def match_tags(text)
    tags = []

    words = WordsCollection.new(text)

    Tag.find_each do |tag|
      tags << tag if words.match_tag? tag
    end

    tags
  end

  def apply_tags(post, tags)
    post.tags_list = ''

    post.tags_list = tags.map(&:title).join(', ')

    tags.each do |tag|
      tag.post_ids << post.id
      tag.save
    end

    (post.tags_was - post.tags).each do |tag|
      tag.post_ids.delete post.id
      tag.save
    end

    post.save
  end
end
