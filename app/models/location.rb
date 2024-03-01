class Location < ApplicationRecord
  belongs_to :countries, class_name: "Country", foreign_key: "countries_id"
  has_many :locations_movies
  has_many :movies, through: :locations_movies
end
