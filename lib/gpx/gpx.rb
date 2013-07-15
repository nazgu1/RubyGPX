require 'time'
require 'nokogiri'

module GPX
	
	# Class is responsible for parsing GPX files and calculate track statistics
	class GPX
		attr_reader :points_count,
								:points,
								:times,
								:speeds,
								:distances,
								:average_speed,
								:max_speed,
								:start_date,
								:end_date
		
		def points_count
		 	(@points) ? @points.count : 0
		end
		
		def start_date
			@dates.first
		end
		
		def end_date
			@dates.last
		end
		
		def speeds
			unless @speeds
				@speeds = self.distances.zip(self.times).collect do |dist,time|
					dt = time[:dt]
					unless dt == 0
						next dist[:ds]/dt*3600 
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
				total_time = self.times.last[:t]
				@average_speed = self.distances.last[:s] / total_time * 3600 unless total_time==0
			end
			@average_speed
		end
		
		def times
			calculate_times unless @times
			@times
		end
		
		def distances
			calculate_distances unless @distances
			@distances
		end
		
		def initialize(path)
			@doc = nil
	
			begin
				path = open(path)
				doc = Nokogiri::XML(path)
			rescue
				raise GPXInvalidFileException
			end
	
			# raise GPXInvalidFileException if doc.children.empty?
			
			@points = []
			@dates = []
			
			doc.search('trkpt').map do |el| 
				@dates.push Time.parse(el.at('time').text)
				@points.push GeoPoint.new(
					latitude: el['lat'].to_f,
					longitude: el['lon'].to_f,
					elevation: el.at('ele').text.to_f
				)
			end
		end
		
		private
		
			def calculate_times
				@times = [ { dt: 0.0, t: 0.0 } ]
				@dates.each_cons(2) do |date|
					time = {
						dt: difference = date[1] - date[0],
						t: difference + @times.last[:t]
					}
					@times.push time
				end
			end
			
			def calculate_distances
				@distances = [ {ds: 0.0, s: 0.0} ]
				@points.each_cons(2) do |point|
					distance = { 
						ds: difference = Haversine.distance(point[0], point[1]),
						s: difference + @distances.last[:s]
					}
					@distances.push distance
				end
			end
		
	end
	
end