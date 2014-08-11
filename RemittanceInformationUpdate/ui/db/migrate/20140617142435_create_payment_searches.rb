class CreatePaymentSearches < ActiveRecord::Migration
  def change
    create_table :payment_searches do |t|

      t.timestamps
    end
  end
end
