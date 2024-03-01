class Movie < ApplicationRecord
  belongs_to :director, class_name: "Director", foreign_key: "director_id"
  has_many :reviews
  has_many :actors_movies, class_name: "ActorsMovie"
  has_many :actors, through: :actors_movies
  scope :search_by_actor_name, ->(actor_name) {
          joins(:actors).where("actors.name LIKE ?", "%#{actor_name}%")
        }
  has_many :locations_movies
  has_many :locations, through: :locations_movies

  def self.fetch_average_review
    Movie.select("movies.id as movie_id, AVG(reviews.stars) AS average_review,count(reviews.stars) as stars_count").left_joins(:reviews).group("movies.id").all.each do |average|
      REDIS_CLIENT.hset("movie_#{average["movie_id"]}", "average", average["average_review"] || 0)
      REDIS_CLIENT.hset("movie_#{average["movie_id"]}", "count", average["stars_count"] || 0)
      REDIS_CLIENT.hset("movie_#{average["movie_id"]}", "sum", average["stars_count"] || 0)
    end
  end

  def average_review
    REDIS_CLIENT.hget("movie_#{self.id}", "average")
  end

  def self.set_average_review(movie_id,stars)
    current_review = REDIS_CLIENT.hgetall("movie_#{movie_id}")
    current_review["count"] = current_review["count"].to_i + 1
    current_review["sum"] = current_review["sum"].to_i + stars.to_i
    if current_review["sum"].to_i > 0
      current_review["average"] = current_review["sum"] / current_review["sum"]
    else
      current_review["average"] = 0
    end
    REDIS_CLIENT.hset("movie_#{movie_id}", "average", current_review["average"] || 0)
    REDIS_CLIENT.hset("movie_#{movie_id}", "count", current_review["count"] || 0)
    REDIS_CLIENT.hset("movie_#{movie_id}", "sum", current_review["sum"] || 0)
    self.average_review = current_review["average"]
    self.save!
  end
end
