require "gpx/version"
require "gpx/haversine"
require "gpx/exceptions"

require 'time'
require 'nokogiri'

module GPX
	class GPX
		attr_reader :pointsCount,
								:elevations,
								:coordinates,
								:times,
								:timesCumulated,
								:speeds,
								:distances
		
		def pointsCount
		 	(@coordinates) ? @coordinates.count : 0
		end
		
		def initialize(path)
			doc = nil

			begin
				path = open(path)
				doc = Nokogiri::XML(path)
			rescue
				raise GPXInvalidFileException
			end

			raise GPXInvalidFileException if doc.children.empty?
			
			coords = []
			elevs = []
			distances = [0.0]	
			dates = []
			times = [0.0]
			timesCumulated = [0.0]
			speeds = []
			
			doc.search('trkpt').map do |el|
				coords.push [ el['lat'].to_f, el['lon'].to_f ]
				dates.push Time.parse(el.at('time').text)
				elevs.push el.at('ele').text.to_f
			end
			
			dates.each_cons(2) do |s|
				difference = s[1]-s[0]
				times.push difference
				timesCumulated.push timesCumulated.last + difference
			end
			
			coords.zip(elevs).each_cons(2) do |x|
				pointA = x[0]
				pointB = x[1]
				distances.push dif = Haversine.distance(pointA[0][0], pointA[0][1], pointA[1], pointB[0][0], pointB[0][1], pointB[1])
			end
			
			speeds = distances.zip(times).collect do |d,dt|
				next d/dt*3600 unless dt==0
				next 0 if dt==0
			end
			
			@coordinates = coords
			@elevations  = elevs
			@times       = times
			@timesCumulated = timesCumulated
			@distances   = distances
			@speeds      = speeds
		end
	end
end
