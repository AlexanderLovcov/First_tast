class FixArtUrlName < ActiveRecord::Migration[7.0]
  def change
    rename_column :articles, :url_of_article, :url
  end
end
