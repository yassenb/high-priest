class CreateSpells < ActiveRecord::Migration
  def change
    create_table :spells do |t|
      t.integer :player_id, null: false
      t.integer :spell_id, null: false
    end
  end
end
