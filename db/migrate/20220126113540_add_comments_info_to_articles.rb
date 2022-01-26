class AddCommentsInfoToArticles < ActiveRecord::Migration[7.0]
  def change
    add_column(:articles, :number_of_comments, :integer)
  end
end
