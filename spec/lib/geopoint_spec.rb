require 'spec_helper'

describe GPX::GeoPoint do
	
	before do
		@geopoint = GPX::GeoPoint.new(latitude: 0, longitude: 0, elevation: 0)
	end
	
	subject { @geopoint }
	
	it { should respond_to :latitude }
	it { should respond_to :latitude= }
	
	it { should respond_to :longitude }
	it { should respond_to :longitude= }
	
	it { should respond_to :elevation }
	it { should respond_to :elevation= }
end