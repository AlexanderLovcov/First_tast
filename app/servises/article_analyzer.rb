require 'nokogiri'
require 'open-uri'

class ArticleAnalyzer
  def self.count_comments(article)
    art_url = article.url_of_article
    art_url = article.url_of_article.gsub('.html', '') + '/comments.html#comments' unless art_url.include? '/comments.html#comments'

    doc = Nokogiri::HTML(URI.open('%s' % [art_url]))
    doc.css('div.onecomm p.author span.about strong.name').map do |name|
      name.content
    end.count
  end

  def self.article_name(url_of_article)
    doc = Nokogiri::HTML(URI.open('%s' % [url_of_article]))
    doc.css('h1').text
  end
end