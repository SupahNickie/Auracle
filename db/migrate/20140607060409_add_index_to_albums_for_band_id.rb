class AddIndexToAlbumsForBandId < ActiveRecord::Migration
  def change
    add_index :albums, :band_id
  end
end
