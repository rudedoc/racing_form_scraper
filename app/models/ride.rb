require "csv"

class Ride < ApplicationRecord
  belongs_to :horse
  belongs_to :jockey
  belongs_to :trainer
  belongs_to :owner
  belongs_to :race

  delegate :meeting, to: :race

  INSIGHT_SCORE_MAPPING = {
    "AHEAD_OF_THE_HANDICAPPER" => 3,
    "HOT_JOCKEY" => 2,
    "HOT_TRAINER" => 2,
    "TRAVELLERS_CHECK" => 2,
    "WIND_SURGERY_SINCE_LAST_RUN" => 2,
    nil => 1,
    "FIRST_TIME_TONGUE_STRAP" => 0,
    "FIRST_TIME_HOOD" => 0,
    "FIRST_TIME_VISOR" => 0,
    "FIRST_TIME_BLINKERS" => 0,
    "FIRST_TIME_EYE_SHIELD" => 0,
    "FIRST_TIME_EYE_COVER" => 0,
    "FIRST_TIME_CHEEK_PIECES" => 0
  }

  def head_gear_score
    headgear&.any? ? 0 : 1
  end

  def insight_score
    insights.compact.sum { |insight| INSIGHT_SCORE_MAPPING[insight] }
  end

  def as_json
    # Flatten the structure
    {
      id: id,
      # Ride specific data
      finish_position: finish_position,
      official_rating: official_rating,
      jockey_claim: jockey_claim,
      handicap_pounds: handicap_pounds,
      starting_price_decimal: starting_price_decimal,
      horse_lifetime_stats_run_count: horse_lifetime_stats_run_count,
      horse_lifetime_stats_win_count: horse_lifetime_stats_win_count,
      horse_lifetime_stats_place_count: horse_lifetime_stats_place_count,
      # Insights
      insight_score: insight_score,
      # head gear
      head_gear_score: head_gear_score,
      horse_name: horse.name,
      horse_age: horse.age,
      horse_sex: horse.sex,
      jockey_name: jockey.name,
      trainer_name: trainer.name,
      owner_name: owner.name,

      race_id: race.id,
      race_handicap: race.handicap?,
      race_hurdle: race.hurdle?,
      race_chase: race.chase?,
      race_maiden: race.maiden?,
      race_novices: race.novices?,
      race_flat: race.flat?,
      race_nursery: race.nursery?,
      race_stakes: race.stakes?,
      race_fillies: race.fillies?,
      race_group_1: race.group_1?,
      race_group_2: race.group_2?,
      race_group_3: race.group_3?,
      race_listed: race.listed?,
      race_date: race.date,
      race_winning_time_seconds: race.winning_time_seconds,
      race_class: race.race_class.to_i,
      race_going: race.going,
      race_distance_yards: race.distance_yards,

      meeting_name: meeting.name,
      meeting_country: meeting.country_name,
      meeting_weather: meeting.weather_group,
      meeting_surface: meeting.surface_summary
    }
  end

  def self.to_csv
    file_path = "rides.csv"
    headers = Ride.first.as_json.keys
    ride_count = Ride.count
    CSV.open(file_path, "wb", write_headers: true, headers: headers) do |csv|
      Ride.find_each(batch_size: 1000) do |ride|
        ride_count -= 1
        next if ride.betting.empty?
        next if ride.race.winning_time.nil?

        csv << ride.as_json.values rescue binding.pry
        puts "#{ride_count} rides remaining" if ride_count % 100 == 0
      end
    end
    puts "Rides have been exported to #{file_path}"
  end

  def starting_price
    betting.last
  end

  def starting_price_decimal
    numerator, denominator = starting_price.split("/").map(&:to_f)
    (numerator / denominator) + 1
  end

  def handicap_pounds
    return nil unless handicap.present?

    parts = handicap.split("-")
    stones = parts[0].to_i
    pounds = parts[1].to_i

    total_pounds = (stones * 14) + pounds
    total_pounds
  end
end
