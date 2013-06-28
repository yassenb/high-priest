class AddSwappedAllyAndSwappedSpellToPlayer < ActiveRecord::Migration
  def change
    add_column :players, :swapped_ally, :boolean, null: false, default: false
    add_column :players, :swapped_spell, :boolean, null: false, default: false
  end
end
