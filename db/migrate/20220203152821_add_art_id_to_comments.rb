class AddArtIdToComments < ActiveRecord::Migration[7.0]
  def change
    add_reference :comments, :article, foreign_key: true
  end
end
