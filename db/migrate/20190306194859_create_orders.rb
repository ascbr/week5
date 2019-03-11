  class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.integer :quantity
      t.references :purchase, foreign_key: true, index: true
      t.references :product, foreign_key: true, index: true

      t.timestamps
    end
  end
end
