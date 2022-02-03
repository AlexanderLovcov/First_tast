class Article < ApplicationRecord
  has_many :comments, dependent: :destroy

  validates :url, presence: true
  def fetched?

  end
end
