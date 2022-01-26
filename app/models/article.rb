class Article < ApplicationRecord
  validates :title, presence: true
  validates :url_of_article, presence: true

end
