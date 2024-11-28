# README

# Horse
rails generate model Horse name:string age:integer foaled:date sex:string


# Jockey
rails generate model Jockey name:string

# Trainer
rails generate model Trainer name:string

# Owner
rails generate model Owner name:string

# Meeting

# Race

# Ride

rails generate model Ride finish_position:integer ride_status:string handicap:string headgear:text official_rating:integer jockey_claim:float ride_description:text betting:text horse:references jockey:references trainer:references owner:references casualty:string insights:string horse_lifetime_stats_run_count:integer horse_lifetime_stats_win_count:integer horse_lifetime_stats_place_count:integer commentary:text


# Result
