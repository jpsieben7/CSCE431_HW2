class Movie < ActiveRecord::Base
    def self.all_ratings
        return Movie.uniq.pluck(:rating)
    end
end
