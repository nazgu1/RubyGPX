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
								:distances,
								:distancesCumulated,
								:averageSpeed,
								:maxSpeed,
								:startDate,
								:endDate
		
		def pointsCount
		 	(@coordinates) ? @coordinates.count : 0
		end
		
		def startDate
			@dates.first
		end
		
		def endDate
			@dates.last
		end
		
		def speeds
			unless @speeds
				@speeds = self.distances.zip(self.times).collect do |d,dt|
					next d/dt*3600 unless dt==0
					next 0 if dt==0
				end
			end
			@speeds
		end
		
		def maxSpeed
			unless @maxSpeed
				@maxSpeed = self.speeds.sort_by{|a| a}.last
			end
			@maxSpeed
		end
		
		def averageSpeed
			unless @averageSpeed
				@averageSpeed = 0
				@averageSpeed = self.distancesCumulated.last / self.timesCumulated.last * 3600 unless self.timesCumulated.last==0
			end
			@averageSpeed
		end
		
		def times
			calculateTimes unless @times
			@times
		end
		
		def timesCumulated
			calculateTimes unless @timesCumulated
			@timesCumulated
		end
		
		def distances
			calculateDistances unless @distances
			@distances
		end
		
		def distancesCumulated
			calculateDistances unless @distancesCumulated
			@distancesCumulated
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
			
			@coordinates = []
			@elevations = []
			@dates = []
			
			doc.search('trkpt').map do |el|
				@coordinates.push [ el['lat'].to_f, el['lon'].to_f ]
				@dates.push Time.parse(el.at('time').text)
				@elevations.push el.at('ele').text.to_f
			end
		end
		
		private
		
			def calculateTimes
				@times = [0.0]
				@timesCumulated = [0.0]
				@dates.each_cons(2) do |s|
					difference = s[1]-s[0]
					@times.push difference
					@timesCumulated.push difference + @timesCumulated.last 
				end
			end
			
			def calculateDistances
				@distances = [0.0]	
				@distancesCumulated = [0.0]
				@coordinates.zip(@elevations).each_cons(2) do |x|
					pointA = x[0]
					pointB = x[1]
					difference = Haversine.distance(pointA[0][0], pointA[0][1], pointA[1], pointB[0][0], pointB[0][1], pointB[1])
					@distances.push difference
					@distancesCumulated.push difference + @distancesCumulated.last
				end
			end
		
	end
end
