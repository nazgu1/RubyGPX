require "gpx/version"
require "gpx/haversine"
require "gpx/exceptions"

require 'time'
require 'nokogiri'

module GPX
	class GPX
		attr_reader :pointsCount, :elevations, :coordinates, :times, :speeds, :distances
		
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
			elevs  = []
			times  = []
			speeds = []
			distances = []
			
			distances = [0.0]
			
			doc.search('trkpt').map do |el|
				coords.push [ el['lat'].to_f, el['lon'].to_f ]
				times.push Time.parse(el.at('time').text)
				elevs.push el.at('ele').text.to_f
			end
			
			coords.zip(elevs).each_cons(2) do |x|
				distances.push dif = Haversine.distance(x[0][0][0], x[0][0][1], x[0][1], x[1][0][0], x[1][0][1], x[1][1])
			end
			
			speeds = distances.zip(times).collect do |d,dt|
				dt = dt.to_f
				d/dt*3600 unless dt==0
			end
			
			@coordinates = coords
			@elevations  = elevs
			@times       = times
			@distances   = distances
			@speeds      = speeds
		end
	end
end
