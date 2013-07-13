require "gpx/version"
require "gpx/haversine"
require "gpx/exceptions"

require 'time'
require 'nokogiri'

module GPX
	class GPX
		attr_reader :pointsCount, :elevations, :coordinates, :times, :speeds
		
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
			
			doc.search('trkpt').map do |el|
				coords.push [ el['lat'].to_f, el['lon'].to_f ]
				times.push Time.parse(el.at('time').text)
				elevs.push el.at('ele').text.to_f
			end
			
			@coordinates = coords
			@elevations  = elevs
			@times       = times
			@speeds      = speeds
		end
	end
end
