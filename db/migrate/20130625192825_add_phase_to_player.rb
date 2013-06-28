class AddPhaseToPlayer < ActiveRecord::Migration
  def change
    add_column :players, :phase, :string, null: false, default: "joined"
  end
end
