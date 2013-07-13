require 'spec_helper'

describe GPX do
	let(:zabrze_lat) { 18.7833 }
	let(:zabrze_lon) { 50.3167 }
	let(:katowice_lat) { 19.0167 }
	let(:katowice_lon) { 50.2667 }
	let(:katowice_distance) { 17.47 }
	
	it "should return proper distance for two values" do
		distance = GPX::Haversine.distance(zabrze_lat, zabrze_lon, katowice_lat, katowice_lon)
		distance.should eq katowice_distance
	end
end