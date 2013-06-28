class AddHeroIdToPlayer < ActiveRecord::Migration
  def change
    add_column :players, :hero_id, :integer
  end
end
