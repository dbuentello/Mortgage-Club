class AddZillowImageUrlToProperty < ActiveRecord::Migration
  def change
    add_column :properties, :zillow_image_url, :string
  end
end
