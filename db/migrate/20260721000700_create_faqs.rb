class CreateFaqs < ActiveRecord::Migration[8.0]
  def change
    create_table :faqs do |t|
      t.string :question_ar
      t.string :question_en
      t.text :answer_ar
      t.text :answer_en
      t.references :parentable, polymorphic: true, index: true
      t.boolean :is_deleted, default: false
      t.boolean :is_published, default: false
      t.integer :user_id

      t.timestamps
    end
  end
end
