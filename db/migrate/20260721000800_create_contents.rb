class CreateContents < ActiveRecord::Migration[8.0]
  def change
    create_table :contents do |t|
      t.text :content_ar
      t.text :content_en
      t.references :parentable, polymorphic: true, index: true
      t.integer :user_id
      t.boolean :is_deleted, default: false
      t.boolean :is_published, default: false

      t.timestamps
    end
  end
end
