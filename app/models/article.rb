class Article < ApplicationRecord
  has_many :comments, dependent: :destroy

  validates :url, presence: true
end
