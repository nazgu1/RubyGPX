require 'spec_helper'

PRECISION = 0.002 # 0.01%

describe GPX::Haversine do
	def should_equals_distance_with_precision(checked_distance, real_distance)
    (checked_distance-real_distance).abs.should < real_distance * PRECISION
  end
	
	let(:zabrze) { GPX::GeoPoint.new(latitude: 50.3167, longitude: 18.7833, elevation: 0)  }
	let(:katowice) { GPX::GeoPoint.new(latitude: 50.2667, longitude: 19.0167, elevation: 0) }
	let(:katowice_distance) { 17.47 }
	
	it "should return proper distance from Zabrze, PL to Katowice, PL" do
		distance = GPX::Haversine.distance(zabrze, katowice)
		should_equals_distance_with_precision(distance, katowice_distance)
	end
	
	it "should return proper distance from Katowice, PL to Zabrze, PL" do
		distance = GPX::Haversine.distance(katowice, zabrze)
		should_equals_distance_with_precision(distance, katowice_distance)
	end
	
	let(:tokyo) { GPX::GeoPoint.new(latitude: 35.6850, longitude: 139.7514, elevation: 0) }
	let(:london) { GPX::GeoPoint.new(latitude: 51.5000, longitude: -0.1167, elevation: 0) }
	let(:london_distance) { 9554.72 }
  
  it "should return proper distance from Tokyo, JP to London, GB" do
  	distance = GPX::Haversine.distance(tokyo, london)
  	should_equals_distance_with_precision(distance, london_distance)
  end

	it "should return proper length of half of equinox" do
		distance = GPX::Haversine.distance(
			GPX::GeoPoint.new(latitude: 0, longitude: 0, elevation: 0),
			GPX::GeoPoint.new(longitude: 0, longitude: 180, elevation: 0)
		)
		should_equals_distance_with_precision(distance, 20038)
	end
  
  let(:same_point) { GPX::GeoPoint.new(latitude: 44.654, longitude: 44.654, elevation: 0) }
  it "should return 0 for same lat/lon" do
  	distance = GPX::Haversine.distance(same_point,same_point)
  	distance.should eq 0
  end
  
  let(:height) { GPX::GeoPoint.new(latitude: 44.654, longitude: 44.654, elevation: 1233.54) }
  it "should return proper height for same lat/lon" do
		distance = GPX::Haversine.distance(same_point, height)
		distance.should eq height.elevation/1000
  end
  
end