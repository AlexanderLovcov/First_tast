require 'nokogiri'
require 'open-uri'
require 'net/https'
require 'uri'
require 'json'

class ArticleAnalyzer

  ENDPOINT = 'https://article-analazer-anendo8.cognitiveservices.azure.com/'.freeze
  PATH = '/text/analytics/v3.0/sentiment'.freeze

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
      { id: comment.id, language: 'en', text: comment.comment_text }
    end

    uri = URI(ENDPOINT + PATH)
    documents = { 'documents': comments }

    response = JSON.parse(ArticleAnalyzer.handle_request(uri, ArticleAnalyzer.build_request(documents, uri)).body)
    response['documents'].map { |comment| comment['confidenceScores'].each_with_object({}) { |(k, v), h| h.merge!(k => v * 100) } }
  end

  def self.build_request(documents, uri)
    request = Net::HTTP::Post.new(uri)
    request['Content-Type'] = "application/json"
    request['Ocp-Apim-Subscription-Key'] = ENV["SUBSCRIPTION_KEY"]
    request.body = documents.to_json
    request
  end

  def self.handle_request(uri, request)
    Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
      http.request(request)
    end
  end
end