class CreateOperationPhotos < ActiveRecord::Migration[8.0]
  def change
    create_table :operation_photos do |t|
      t.references :operation, null: false, foreign_key: true
      t.string :alt_ar
      t.string :alt_en
      t.boolean :is_landing

      t.timestamps
    end
  end
end
