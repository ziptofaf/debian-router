class CreateAdapters < ActiveRecord::Migration
  def change
    create_table :adapters do |t|
      t.string :name
      t.integer :wifi
      t.integer :internet_source
      t.string :ip_adress
      t.string :mask
      t.integer :security
      t.integer :dhcp
      t.string :ssid
      t.string :password

      t.timestamps null: false
    end
  end
end
