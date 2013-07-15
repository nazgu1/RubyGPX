require 'time'
require 'nokogiri'

module GPX
	
	# Class is responsible for parsing GPX files and calculate track statistics
	class GPX
		attr_reader :points_count,
								:elevations,
								:coordinates,
								:times,
								:times_cumulated,
								:speeds,
								:distances,
								:distances_cumulated,
								:average_speed,
								:max_speed,
								:start_date,
								:end_date
		
		def points_count
		 	(@coordinates) ? @coordinates.count : 0
		end
		
		def start_date
			@dates.first
		end
		
		def end_date
			@dates.last
		end
		
		def speeds
			unless @speeds
				@speeds = self.distances.zip(self.times).collect do |dist,dt|
					unless dt == 0
						next dist/dt*3600 
					else
						next 0
					end
				end
			end
			@speeds
		end
		
		def max_speed
			unless @max_speed
				@max_speed = self.speeds.sort_by{|speed| speed}.last
			end
			@max_speed
		end
		
		def average_speed
			unless @average_speed
				@average_speed = 0
				total_time = self.times_cumulated.last
				@average_speed = self.distances_cumulated.last / total_time * 3600 unless total_time==0
			end
			@average_speed
		end
		
		def times
			calculate_times unless @times
			@times
		end
		
		def times_cumulated
			calculate_times unless @times_cumulated
			@times_cumulated
		end
		
		def distances
			calculate_distances unless @distances
			@distances
		end
		
		def distances_cumulated
			calculate_distances unless @distances_cumulated
			@distances_cumulated
		end
		
		def initialize(path)
			doc = nil
	
			begin
				path = open(path)
				doc = Nokogiri::XML(path)
			rescue
				raise GPXInvalidFileException
			end
	
			# raise GPXInvalidFileException if doc.children.empty?
			
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
		
			def calculate_times
				@times = [0.0]
				@times_cumulated = [0.0]
				@dates.each_cons(2) do |date|
					@times.push difference = date[1]-date[0]
					@times_cumulated.push difference + @times_cumulated.last 
				end
			end
			
			def calculate_distances
				@distances = [0.0]	
				@distances_cumulated = [0.0]
				@coordinates.zip(@elevations).each_cons(2) do |point|
					first_point = GeoPoint.new(point[0][0][0], point[0][0][1], point[0][1])
					second_point = GeoPoint.new(point[1][0][0], point[1][0][1], point[1][1])
					@distances.push difference = Haversine.distance(first_point, second_point)
					@distances_cumulated.push difference + @distances_cumulated.last
				end
			end
		
	end
	
end