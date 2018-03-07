class AddDefaultsForAccessTokenScopeAndAccessTokenTypeToTokens < ActiveRecord::Migration[5.1]
  def change
    change_column_default :tokens, :access_token_type, from: nil, to: 'bearer'
    change_column_default :tokens, :access_token_scope, from: nil, to: 'basic'
  end
end
