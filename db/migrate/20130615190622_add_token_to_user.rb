class AddTokenToUser < ActiveRecord::Migration
  class User < ActiveRecord::Base
  end

  def change
    add_column :users, :token, :string, null: false
    User.reset_column_information
    User.all.each do |user|
      user.update_attributes! token: SecureRandom.base64(20)
    end
  end
end
