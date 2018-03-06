class AddUserIdToTokens < ActiveRecord::Migration[5.1]
  def change
    add_reference :tokens, :user, foreign_key: true
  end
end
