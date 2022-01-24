json.extract! article, :id, :title, :url_of_article, :created_at, :updated_at
json.url article_url(article, format: :json)
