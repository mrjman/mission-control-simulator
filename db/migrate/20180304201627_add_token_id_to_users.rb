class AddTokenIdToUsers < ActiveRecord::Migration[5.1]
  def change
    add_reference :users, :token, foreign_key: true
  end
end
