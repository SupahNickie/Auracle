class CreateAlbums < ActiveRecord::Migration
  def change
    create_table :albums do |t|
      t.string :title
      t.integer :user_id
      t.attachment :album_art

      t.timestamps
    end
  end
end
