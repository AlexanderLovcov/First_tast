require 'nokogiri'
require 'open-uri'

class CommentsCountAnalyzer
  def self.perform(article)
    list_of_author_names = []
    art_url = article.url_of_article

    if art_url.include? '/comments.html#comments'
      doc = Nokogiri::HTML(URI.open('%s' % [art_url]))
    else
      art_url = article.url_of_article.gsub('.html', '') + '/comments.html#comments'
      doc = Nokogiri::HTML(URI.open('%s' % [art_url]))
    end

    doc.css('div.onecomm p.author span.about strong.name').each do |name|
      list_of_author_names.append(name.content)
    end

    #Can use i++, but list of authors can be used after
    list_of_author_names.count
  end

  def self.get_article_name(url_of_article)
    doc = Nokogiri::HTML(URI.open('%s' % [url_of_article]))
    doc.css('h1').text
  end
end