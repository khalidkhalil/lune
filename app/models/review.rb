class Review < ApplicationRecord
  belongs_to :movie, class_name: "Movie"
  belongs_to :user, class_name: "User"


  def self.set_average(movie) 

  end
end
