class Movie < ApplicationRecord
  belongs_to :director, class_name: "Director", foreign_key: "director_id"
  has_many :reviews
  has_many :actors_movies,class_name: 'ActorsMovie'
  has_many :actors, through: :actors_movies
  scope :search_by_actor_name, ->(actor_name) {
    joins(:actors).where("actors.name LIKE ?", "%#{actor_name}%")
  }
  has_many :locations_movies
  has_many :locations, through: :locations_movies
end
