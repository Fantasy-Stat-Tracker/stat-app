namespace :data_2014 do
  task :add_games => :environment do
    require 'google/apis/sheets_v4'
    require 'googleauth'
    require 'googleauth/stores/file_token_store'
    require 'fileutils'

    OOB_URI = 'urn:ietf:wg:oauth:2.0:oob'.freeze
    APPLICATION_NAME = 'Google Sheets API Ruby Quickstart'.freeze
    CREDENTIALS_PATH = 'credentials.json'.freeze
    # The file token.yaml stores the user's access and refresh tokens, and is
    # created automatically when the authorization flow completes for the first
    # time.
    TOKEN_PATH = 'token.yaml'.freeze
    SCOPE = Google::Apis::SheetsV4::AUTH_SPREADSHEETS_READONLY

    def authorize
      client_id = Google::Auth::ClientId.from_file(CREDENTIALS_PATH)
      token_store = Google::Auth::Stores::FileTokenStore.new(file: TOKEN_PATH)
      authorizer = Google::Auth::UserAuthorizer.new(client_id, SCOPE, token_store)
      user_id = 'default'
      credentials = authorizer.get_credentials(user_id)
      if credentials.nil?
        url = authorizer.get_authorization_url(base_url: OOB_URI)
        puts 'Open the following URL in the browser and enter the ' \
            "resulting code after authorization:\n" + url
        code = gets
        credentials = authorizer.get_and_store_credentials_from_code(
          user_id: user_id, code: code, base_url: OOB_URI
        )
      end
      credentials
    end

    # Initialize the API
    service = Google::Apis::SheetsV4::SheetsService.new
    service.client_options.application_name = APPLICATION_NAME
    service.authorization = authorize

    spreadsheet_id = '1kLvCUN0cH5j1bQNemUpY7uIQdZK_alYr5FIZt7fPaTU'
    range = '2014!A2:J83'
    response = service.get_spreadsheet_values(spreadsheet_id, range)
    puts 'No data found.' if response.values.empty?
    year_season = Season.create(year: 2014) unless response.values.empty?
    response.values.each do |row|
      # Print columns A and E, which correspond to indices 0 and 4.
      # puts "name: #{row[0]}, email: #{row[3]}"
      week = Week.find_or_create_by(number: row[1], season_id: year_season.id)
      home_user = User.find_by(first_name: row[3], last_name: row[4])
      away_user = User.find_by(first_name: row[6], last_name: row[7])
      UserSeason.find_or_create_by(season_id: year_season.id, user_id: home_user.id)
      Game.create(game_type: row[0], week_id: week.id, home_score: row[8], away_score: row[9], home_id: home_user.id, away_id: away_user.id)
    end
  end
end
