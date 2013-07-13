module GPX
	class Haversine
		RADIAN_PER_DEGREE = Math::PI/180.0
		EARTH_RADIUS = 6371.00079
		
		def self.distance(latitudeA, longitudeA, elevationA, latitudeB, longitudeB, elevationB)
			latitudeA_rad = latitudeA*RADIAN_PER_DEGREE
			latitudeB_rad = latitudeB*RADIAN_PER_DEGREE
			
			distance_latitude = (latitudeB-latitudeA) * RADIAN_PER_DEGREE
			distance_longitude = (longitudeB-longitudeA) * RADIAN_PER_DEGREE
			
			a = (Math::sin(distance_latitude/2.0)**2.0) +
						Math::cos(latitudeA_rad) * Math::cos(latitudeB_rad) * (Math::sin(distance_longitude/2.0)**2.0)
			c = 2.0 * Math::atan2(Math::sqrt(a), Math::sqrt(1.0-a))
			
			distance = EARTH_RADIUS * c
			elevation = (elevationA/1000.0-elevationB/1000.0).abs
			
			Math::sqrt(distance**2 + elevation**2)
		end
	end
end