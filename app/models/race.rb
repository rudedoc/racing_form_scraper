class Race < ApplicationRecord
  belongs_to :meeting
  has_many :rides

  def as_json(options = {})
    super(options.merge(except: [ :created_at, :updated_at ])).merge(rides: rides.as_json).deep_symbolize_keys
  end

  def distance_yards
    return 0 unless distance.present?

    total_yards = 0
    # Regex to extract numbers before 'm', 'f', and 'y'
    matches = distance.match(/(?:(\d+)m)?\s*(?:(\d+)f)?\s*(?:(\d+)y)?/)

    # Add yards for miles
    total_yards += matches[1].to_i * 1760 if matches[1]
    # Add yards for furlongs
    total_yards += matches[2].to_i * 220 if matches[2]
    # Add remaining yards
    total_yards += matches[3].to_i if matches[3]

    total_yards
  end

  def winning_time_seconds
    # Extract the minutes and seconds from the winning_time attribute
    # This regex captures the minutes and seconds parts separately
    matches = winning_time.match(/(?:(\d+)m )?(\d+\.?\d*)s/)

    # Initialize variables for minutes and seconds
    minutes = matches[1].to_i # Convert to integer, safely returns 0 if nil
    seconds = matches[2].to_f # Convert to float to include decimal part

    # Convert the total time to seconds
    total_seconds = (minutes * 60) + seconds
    total_seconds
  end

  def types
    @types ||= begin
      # Define a regex pattern to identify key race types and features
      race_type_regex = /Handicap|Hurdle|Chase|Maiden|Novices|Flat|Nursery|Stakes|Fillies|Group 3|Group 2|Group 1|Listed/
      name.scan(race_type_regex).uniq
    end
  end

  def handicap?
    types.include?("Handicap")
  end

  def hurdle?
    types.include?("Hurdle")
  end

  def chase?
    types.include?("Chase")
  end

  def maiden?
    types.include?("Maiden")
  end

  def novices?
    types.include?("Novices")
  end

  def flat?
    types.include?("Flat")
  end

  def nursery?
    types.include?("Nursery")
  end

  def stakes?
    types.include?("Stakes")
  end

  def fillies?
    types.include?("Fillies")
  end

  def group_1?
    types.include?("Group 1")
  end

  def group_2?
    types.include?("Group 2")
  end

  def group_3?
    types.include?("Group 3")
  end

  def listed?
    types.include?("Listed")
  end
end
