class CreateTokens < ActiveRecord::Migration[5.1]
  def change
    create_table :tokens do |t|
      t.string :access_token
      t.string :client_id
      t.string :client_secret
      t.datetime :access_token_created_at
      t.string :access_token_type
      t.string :access_token_scope

      t.timestamps
    end
  end
end
