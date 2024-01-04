class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :ip_address, null: false
      t.string :recomendation
      t.string :recomendation_type

      t.timestamps
    end
  end
end
