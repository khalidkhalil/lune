class CsvImportJob
  include Sidekiq::Job
  require "csv"

  def perform(movies_file_path, reviews_file_path)
    binding.pry

    # Import movies
    import_movies(movies_file_path) if movies_file_path.present?

    # Import reviews
    import_reviews(reviews_file_path) if reviews_file_path.present?
    # Do something
  end

  def self.movie_mapper
    {
      "name" => 0,
      "description" => 1,
      "year" => 2,
      "director" => 3,
      "actor" => 4,
      "location" => 4,
      "country" => 6,

    }
  end

  def review_mapper
    {
      "movie" => 0,
      "user" => 1,
      "stars" => 2,
      "review" => 3,
    }
  end

  def import_movies(file_path)
    file_path = Rails.root.to_s + "/public/movies.csv"

    csv = CSV.read(file_path, headers: false)
    csv.delete_at(0)
    csv.each do |row|
      movie = Movie.where(name: row[movie_mapper["name"]]).first
      unless movie
        movie = Movie.new
        movie.name = row[movie_mapper["name"]]
      end
      movie.description = row[movie_mapper["description"]]
      movie.year = row[movie_mapper["year"]]
      actor = Actor.find_or_create_by(name: row[movie_mapper["actor"]])
      movie.actors << actor

      ###create location
      location = Location.where(name: row[movie_mapper["location"]]).first
      if !location
        country = Country.create(name: row[movie_mapper["country"]])
        location = Location.create(name: row[movie_mapper["location"]], countries_id: country.id)
      end
      movie.locations << location
      director = Director.find_or_create_by(name: row[movie_mapper["director"]])
      movie.director_id = director.id
      #################
      movie.save!
    end
  end

  def import_reviews(file_path)
    file_path = Rails.root.to_s + "/public/reviews.csv"
    csv = CSV.read(file_path, headers: false)
    csv.delete_at(0)
    response = []
    csv.each do |row|
      res = {}
      begin
        review = Review.includes(:user, :movie).where(users: { name: row[review_mapper["user"]] }).where(movies: { name: row[review_mapper["movie"]] }).first 
        unless review
          review = Review.new
          movie = Movie.where(name: row[review_mapper["movie"]]).first
          if !movie
            raise "No movie found"
          end
        end
        review.movie_id = movie.id

        ####create user
        user = User.find_or_create_by(name: row[review_mapper["user"]])
        ####create user
        review.user_id = user.id
        review.stars = row[review_mapper["stars"]]
        review.content = row[review_mapper["review"]]
        review.save! 
        res["msg"] = "success"
        res["valid"] = true
        res["data"] = review
      rescue => e
        res["msg"] = e.to_s
        res["valid"] = true
      end
      response.push res
    end
    return response
  end
end
