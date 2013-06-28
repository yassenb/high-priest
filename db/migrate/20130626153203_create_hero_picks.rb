class CreateHeroPicks < ActiveRecord::Migration
  def change
    create_table :hero_picks do |t|
      t.integer :player_id, null: false
      t.integer :hero_id, null: false
    end
  end
end
