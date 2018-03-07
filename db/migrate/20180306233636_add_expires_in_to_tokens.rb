class AddExpiresInToTokens < ActiveRecord::Migration[5.1]
  def change
    add_column :tokens, :expires_in, :integer, default: 1.day.to_i
  end
end
