class CreateInquiries < ActiveRecord::Migration[8.0]
  def change
    create_table :inquiries do |t|
      t.string :name
      t.string :mobile
      t.string :email
      t.string :reason
      t.string :preferred_day
      t.text :notes
      t.string :preferred_locale
      t.boolean :handled, default: false

      t.timestamps
    end
  end
end
