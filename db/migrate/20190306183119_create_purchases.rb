class CreatePurchases < ActiveRecord::Migration[5.2]
  def change
    create_table :purchases do |t|
      t.datetime :purchase_date
      t.decimal :total
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
