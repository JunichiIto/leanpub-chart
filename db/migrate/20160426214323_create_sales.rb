class CreateSales < ActiveRecord::Migration
  def change
    create_table :sales do |t|
      t.decimal :cause_royalty_percentage, null: false
      t.decimal :author_royalty_percentage, null: false
      t.decimal :author_royalties, null: false
      t.decimal :cause_royalties, null: false
      t.datetime :author_paid_out_at
      t.datetime :cause_paid_out_at
      t.integer :royalty_days_hold, null: false
      t.decimal :publisher_royalties, null: false
      t.datetime :publisher_paid_out_at
      t.string :author_username, null: false
      t.string :publisher_slug
      t.string :user_email
      t.string :purchase_uuid, null: false
      t.string :invoice_id, null: false
      t.datetime :date_purchased, null: false

      t.timestamps null: false
    end
    add_index :sales, [:purchase_uuid, :author_username], unique: true
  end
end
