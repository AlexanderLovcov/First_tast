class Article < ApplicationRecord
  has_many :comments

  validates :url_of_article, presence: true
end
