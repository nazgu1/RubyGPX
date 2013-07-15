module GPX
	# Class holds coordinates and elevation of single point
	class GeoPoint
		attr_accessor :latitude, :longitude, :elevation
		
		def initialize(latitude: latitude, longitude:longitude, elevation:elevation)
			self.latitude = latitude
			self.longitude = longitude
			self.elevation = elevation
		end
	end
end