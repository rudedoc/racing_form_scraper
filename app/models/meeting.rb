class Meeting < ApplicationRecord
  has_many :races

  def as_json(options = {})
    # exclude create_at and update_at
    super(options.merge(except: [ :created_at, :updated_at ])).merge(races: races.as_json).deep_symbolize_keys
  end

    # Method to categorize the weather condition
    def weather_group
      # Define your weather categories here
      categories = {
        "Sunny" => [ "Bright", "Sunny", "Sunny Intervals", "Fine & Sunny", "Fine & Warm", "Dry & Bright", "Fine & Bright", "Fine", "Dry", "Sunny & Warm", "Overcast & Warm" ],
        "Cloudy" => [ "Cloudy", "Mostly Cloudy", "Overcast", "Fine but Cloudy", "Dry & Cloudy", "Foggy", "Misty" ],
        "Rain" => [ "Drizzle", "Light Rain", "Heavy Rain", "Showers", "Raining", "Heavy Rain Showers", "Light Rain Showers", "Thundery Showers", "Unsettled", "Raining & Windy" ],
        "Cold" => [ "Bright but Cold", "Fine & Cold", "Foggy & Cold", "Sunny & Cold", "Unsettled & Cold", "Overcast & Cold", "Snowing", "Overcast & Cold" ],
        "Windy" => [ "Bright but Windy", "Fine & Windy", "Sunny & Windy", "Dry & Windy", "Overcast & Windy",  "Unsettled & Windy", "Cloudy & Windy", "Windy", "Windy with showers" ]
      }

      # Default category if no match is found
      weather_category = "Other"

      # Check each category to find where the meeting's weather matches
      categories.each do |category, conditions|
        if conditions.any? { |condition| self.weather.include?(condition) }
          weather_category = category
          break
        end
      end

      weather_category
    rescue
      nil
    end
end
