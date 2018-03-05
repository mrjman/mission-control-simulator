namespace :token do
  desc 'Create initial token only if not present'
  task :create => [:environment] do
    return if Token.exists?

    puts 'Error: must define CLIENT_ID in env' if ENV['CLIENT_ID'].blank?
    puts 'Error: must define CLIENT_SECRET in env' if ENV['CLIENT_SECRET'].blank?

    token = Token.create!(
      client_id: ENV['CLIENT_ID'],
      client_secret: ENV['CLIENT_SECRET']
    )

    puts "Success: Created token with access_token #{token.access_token}"
  end

  desc 'Destroy all tokens'
  task :destroy => [:environment] do
    Token.destroy_all

    puts "Success: removed all tokens"
  end

  desc 'Retrieves token'
  task :retrieve => [:environment] do
    puts 'Error: must define CLIENT_ID in env' if ENV['CLIENT_ID'].blank?
    puts 'Error: must define CLIENT_SECRET in env' if ENV['CLIENT_SECRET'].blank?

    token = Token.find_by(
      client_id: ENV['CLIENT_ID'],
      client_secret: ENV['CLIENT_SECRET']
    )

    if token.present?
      puts "Token found with access_token #{token.access_token}"
    else
      puts "Token not found with client_id #{ENV['CLIENT_ID']} and client_secret #{ENV['CLIENT_SECRET']}"
    end
  end
end
