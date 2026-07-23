class CreateContentPhotos < ActiveRecord::Migration[8.0]
  def change
    create_table :content_photos do |t|
      t.references :content, null: false, foreign_key: true
      t.string :alt_ar
      t.string :alt_en

      t.timestamps
    end
  end
end
