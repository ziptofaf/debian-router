class CreateEnvironments < ActiveRecord::Migration
  def change
    create_table :environments do |t|
      t.string :operating_system
      t.string :current_version
      t.integer :adapter_count

      t.timestamps
    end
  end
end
