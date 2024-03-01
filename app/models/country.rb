class Country < ApplicationRecord
    has_many :locations, class_name: "Location"
end
