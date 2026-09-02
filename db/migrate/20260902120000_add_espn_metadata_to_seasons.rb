class AddEspnMetadataToSeasons < ActiveRecord::Migration[8.0]
  def change
    add_column :seasons, :league_name, :string
    add_column :seasons, :team_count, :integer
    add_column :seasons, :scoring_type, :string
    add_column :seasons, :regular_season_matchup_count, :integer
    add_column :seasons, :playoff_team_count, :integer
    add_column :seasons, :playoff_matchup_period_length, :integer
    add_column :seasons, :playoff_seeding_rule, :string
    add_column :seasons, :playoff_matchup_tie_rule, :string
    add_column :seasons, :scoring_settings, :jsonb, default: {}, null: false
    add_column :seasons, :matchup_periods, :jsonb, default: {}, null: false
  end
end
