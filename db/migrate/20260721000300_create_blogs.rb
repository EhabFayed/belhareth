class CreateBlogs < ActiveRecord::Migration[8.0]
  def change
    create_table :blogs do |t|
      t.string :photo_id
      t.string :title_ar
      t.string :title_en
      t.string :description_ar
      t.string :description_en
      t.string :image_alt_text_ar
      t.string :image_alt_text_en
      t.string :meta_title_ar
      t.string :meta_title_en
      t.string :slug
      t.string :slug_ar
      t.text :meta_description_ar
      t.text :meta_description_en
      t.boolean :is_published, default: false
      t.boolean :is_deleted, default: false
      t.integer :category
      t.integer :user_id

      t.timestamps
    end
    add_index :blogs, :slug, unique: true
    add_index :blogs, :slug_ar, unique: true
  end
end
