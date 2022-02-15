require 'nokogiri'
require 'open-uri'
require 'net/https'
require 'uri'
require 'json'

class ArticleAnalyzer
  def self.count_comments(article)
    art_url = article.url
    art_url = article.url.gsub('.html', '') + '/comments.html#comments' unless art_url.include? '/comments.html#comments'

    doc = Nokogiri::HTML(URI.open('%s' % [art_url]))
    doc.css('div.onecomm p.author span.about strong.name').map do |name|
      name.content
    end.count
  end

  def self.article_name(url)
    doc = Nokogiri::HTML(URI.open('%s' % [url]))
    doc.css('h1').text
  end

  def self.get_comments(article)
    art_url = article.url
    art_url = article.url.gsub('.html', '') + '/comments.html#comments' unless art_url.include? '/comments.html#comments'

    doc = Nokogiri::HTML(URI.open('%s' % [art_url]))

    doc.css('div.onecomm p.commtext').map do |commtext|
      Comment.create(comment_text: commtext.content, article_id: article.id)
    end
  end

  def self.analyze_comments(article)
    comments = article.comments.map do |comment|
      { language: 'en', text: comment.comment_text }
    end
    subscription_key = "5a4ef95416fb4d849355e132d0924cde"
    endpoint = "https://article-analazer-anendo8.cognitiveservices.azure.com/"

    path = '/text/analytics/v3.0/sentiment'

    uri = URI(endpoint + path)

    documents = { 'documents': comments }

    request = Net::HTTP::Post.new(uri)
    request['Content-Type'] = "application/json"
    request['Ocp-Apim-Subscription-Key'] = subscription_key
    request.body = documents.to_json

    response = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
      http.request (request)
    end
    response = JSON::pretty_generate (JSON (response.body))
    response = JSON.parse(response)
    response['documents'].map{ |comment| comment['confidenceScores'].each_with_object({}){ |(key, value), hash| hash.merge!(key => value * 100) } }
  end
end