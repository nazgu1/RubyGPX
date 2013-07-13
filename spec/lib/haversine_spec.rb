require 'spec_helper'

PRECISION = 0.002 # 0.01%

describe GPX do
	def should_equals_distance_with_precision(checked_distance, real_distance)
    (checked_distance-real_distance).abs.should < real_distance * PRECISION
  end
	
	let(:zabrze_lon) { 18.7833 }
	let(:zabrze_lat) { 50.3167 }
	let(:katowice_lon) { 19.0167 }
	let(:katowice_lat) { 50.2667 }
	let(:katowice_distance) { 17.47 }
	
	it "should return proper distance from Zabrze, PL to Katowice, PL" do
		distance = GPX::Haversine.distance(zabrze_lat, zabrze_lon, 0, katowice_lat, katowice_lon, 0)
		should_equals_distance_with_precision(distance, katowice_distance)
	end
	
	it "should return proper distance from Katowice, PL to Zabrze, PL" do
		distance = GPX::Haversine.distance(katowice_lat, katowice_lon, 0, zabrze_lat, zabrze_lon, 0)
		should_equals_distance_with_precision(distance, katowice_distance)
	end
	
	let(:tokyo_lon) { 139.7514 }
	let(:tokyo_lat) { 35.6850 }
	let(:london_lon) { -0.1167 }
	let(:london_lat) { 51.5000 }
	let(:london_distance) { 9554.72 }
  
  it "should return proper distance from Tokyo, JP to London, GB" do
  	distance = GPX::Haversine.distance(tokyo_lat, tokyo_lon, 0, london_lat, london_lon, 0)
  	should_equals_distance_with_precision(distance, london_distance)
  end

	it "should return proper length of half of equinox" do
		distance = GPX::Haversine.distance(0,0,0,0,180,0)
		should_equals_distance_with_precision(distance, 20038)
	end
  
  let(:same_point) { 44.654 }
  it "should return 0 for same lat/lon" do
  	distance = GPX::Haversine.distance(same_point,same_point,same_point,same_point,same_point,same_point)
  	distance.should eq 0
  end
  
  let(:height) { 1233.54 }
  it "should return proper height for same lat/lon" do
		distance = GPX::Haversine.distance(same_point,same_point,0,same_point,same_point,height)
		distance.should eq height/1000
  end
  
end