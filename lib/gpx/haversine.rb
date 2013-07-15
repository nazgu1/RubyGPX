module GPX
	
	# Class is responsible for calculating distance between two geo points (it considers point height)
	class Haversine
		RADIAN_PER_DEGREE = Math::PI/180.0
		EARTH_RADIUS = 6371.00079
		
		def self.distance(first_point, second_point)
			first_latitude_rad = first_point.latitude*RADIAN_PER_DEGREE
			second_latitude_rad = second_point.latitude*RADIAN_PER_DEGREE
			
			distance_longitude = (second_point.longitude-first_point.longitude) * RADIAN_PER_DEGREE
			
			elevation = (first_point.elevation/1000.0-second_point.elevation/1000.0).abs
			
			triangulate(EARTH_RADIUS * calculate_distance(first_latitude_rad, second_latitude_rad, distance_longitude), elevation)
		end
		
		private
			def self.calculate_distance(first_latitude_rad, second_latitude_rad, distance_longitude)
				distance_latitude = second_latitude_rad-first_latitude_rad
				coefficient = (Math::sin(distance_latitude/2.0)**2.0) +
							Math::cos(first_latitude_rad) * Math::cos(second_latitude_rad) * (Math::sin(distance_longitude/2.0)**2.0)
							
				2.0 * Math::atan2(Math::sqrt(coefficient), Math::sqrt(1.0-coefficient))
			end
			
			def self.triangulate (distance, height) 
				Math::sqrt(distance**2 + height**2)
			end
	end
end