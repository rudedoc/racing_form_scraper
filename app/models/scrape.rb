require "open-uri"

class Scrape
  def initialize
    date_range = Date.parse("2022-09-09")..Date.parse("2022-09-19")

    date_range.each do |date|
      url = "https://www.sportinglife.com/api/horse-racing/racing/racecards/#{date}"
      meetings = JSON.parse(URI.open(url).read)
      meetings.each do |meeting_data|
        next unless meeting_data["meeting_summary"]["course"]["country"]["long_name"].in?([ "England", "Scotland", "Wales", "Ireland" ])

        db_meeting = Meeting.where(
          id: meeting_data["meeting_summary"]["meeting_reference"]["id"],
          name: meeting_data["meeting_summary"]["course"]["name"],
          country_name: meeting_data["meeting_summary"]["course"]["country"]["long_name"],
          going: meeting_data["meeting_summary"]["going"],
          weather: meeting_data["meeting_summary"]["weather"],
          surface_summary: meeting_data["meeting_summary"]["surface_summary"],
          date: date).first_or_create

        meeting_data["races"].each do |race_data|
          race_attributes = Race.attribute_names - %w[id created_at updated_at]
          # Select only the keys from race_data that exist in the race_attributes
          filtered_race_data = race_data.select { |key, value| race_attributes.include?(key) }
          db_race = Race.where(id: race_data["race_summary_reference"]["id"], meeting_id: db_meeting.id).first_or_create
          db_race.update(filtered_race_data)

          race_url = "https://www.sportinglife.com/api/horse-racing/race/#{db_race.id}"
          race_detail = JSON.parse(URI.open(race_url).read)
          race_detail["rides"].each do |ride_data|
            # Horse
            horse_data = ride_data["horse"]
            horse_attrs = { name: horse_data["name"], age: horse_data["age"], sex: horse_data["sex"]["type"] }
            db_horse = Horse.where(id: ride_data["horse"]["horse_reference"]["id"]).first_or_create
            db_horse.update(horse_attrs)

            # Jockey
            db_jockey = if ride_data["jockey"]["person_reference"]["id"]
              jockey_data = ride_data["jockey"]
              jockey_attrs = { name: jockey_data["name"] }
              db_jockey = Jockey.where(id: ride_data["jockey"]["person_reference"]["id"]).first_or_create
              db_jockey.update(jockey_attrs)
              db_jockey
            end

            # Trainer
            trainer_data = ride_data["trainer"]
            trainer_attrs = { name: trainer_data["name"] }
            db_trainer = Trainer.where(id: ride_data["trainer"]["business_reference"]["id"]).first_or_create
            db_trainer.update(trainer_attrs)

            # Owner
            owner_data = ride_data["owner"]
            owner_attrs = { name: owner_data["name"] }
            db_owner = Owner.where(owner_attrs).first_or_create

            # Ride
            ride_attrs = {
              horse_id: db_horse.id,
              jockey_id: db_jockey&.id,
              trainer_id: db_trainer.id,
              owner_id: db_owner.id,
              race_id: db_race.id,
              finish_position: ride_data["finish_position"],
              ride_status: ride_data["ride_status"],
              handicap: ride_data["handicap"],
              headgear: ride_data["headgear"].map { |hg| hg["name"] },
              casualty: ride_data.dig("casualty", "reason"),
              official_rating: ride_data["official_rating"],
              jockey_claim: ride_data["jockey_claim"],
              ride_description: ride_data["ride_description"],
              commentary: ride_data["commentary"],
              betting: ride_data["betting"]["historical_odds"],
              insights: ride_data["insights"].map { |insight| insight["type"] }
            }

            if ride_data["horse_lifetime_stats"].present?
              ride_attrs.merge!({
                horse_lifetime_stats_run_count: ride_data["horse_lifetime_stats"][0]["run_count"],
                horse_lifetime_stats_win_count: ride_data["horse_lifetime_stats"][0]["win_count"],
                horse_lifetime_stats_place_count: ride_data["horse_lifetime_stats"][0]["place_count"]
              })
            end

            db_ride = Ride.where(id: ride_data["ride_reference"]["id"]).first_or_create
            db_ride.update(ride_attrs)
          end
        end
      end
    end
  end
end
