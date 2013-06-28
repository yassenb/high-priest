class CreateAllies < ActiveRecord::Migration
  def change
    create_table :allies do |t|
      t.integer :player_id, null: false
      t.integer :ally_id, null: false
    end
  end
end
