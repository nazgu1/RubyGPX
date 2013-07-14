require 'spec_helper'

describe GPX do
	
	describe "file with one point" do
		before do
			@gpx = GPX::GPX.new 'spec/assets/one_point.gpx'
		end
		
		subject { @gpx }
		
		it { should respond_to :coordinates }
		it { should_not respond_to :coordinates= }
		
		it { should respond_to :pointsCount }
		it { should_not respond_to :pointsCount= }
		
		it { should respond_to :elevations }
		it { should_not respond_to :elevations= }
		
		it { should respond_to :times }
		it { should_not respond_to :times= }
		
		it { should respond_to :speeds }
		it { should_not respond_to :speeds= }
		
		it { should respond_to :distances }
		it { should_not respond_to :distances= }
		
		it { should respond_to :timesCumulated }
		it { should_not respond_to :timesCumulated= }
		
		it "should return one point" do
			@gpx.pointsCount.should eq 1
		end
		
		it "should return one elevation point" do
			@gpx.elevations.count.should eq 1
		end
		
		it "should return point time" do
			@gpx.times[0].should eq 0
		end
		
		it "should return point cumulated time" do
			@gpx.timesCumulated[0].should eq 0
		end
		
		describe "should return one zero distance (because of one point)" do
			it "distances count should equals one" do
				@gpx.distances.count.should eq 1
			end
			it "first distance should be zero" do
				@gpx.distances[0].should eq 0
			end
		end
		
		describe "should return one zero speed (because of one point)" do
			it "speeds count should equals one" do
				@gpx.speeds.count.should eq 1
			end
			it "first speed should be zero" do
				@gpx.speeds[0].should eq 0
			end
		end
	end
	
	describe "file with more than one track point" do
		POINTS_COUNT = 6
		
		before do
			@gpx = GPX::GPX.new 'spec/assets/two_tracks.gpx'
		end
		
		subject { @gpx }
		
		it "should return all points in one array" do
			@gpx.pointsCount.should eq POINTS_COUNT
		end
		
		it "last point should not be nil" do
			@gpx.coordinates.last.should_not eq nil
		end
		
		it "should return same count of distances elements as points" do
			@gpx.distances.count.should eq POINTS_COUNT
		end
		
		it "last point should not be nil" do
			@gpx.coordinates.last.should_not eq nil
		end
		
		it "should return same count of speeds elements as points" do
			@gpx.speeds.count.should eq POINTS_COUNT
		end
		
		it "last point speed should not be nil" do
			@gpx.speeds.last.should_not eq nil
		end
		
		it "should return same count of time elements as points" do
			@gpx.times.count.should eq POINTS_COUNT
		end
		
		it "last point time should not be nil" do
			@gpx.times.last.should_not eq nil
		end
		
		it "should return same count of cumulated time elements as points" do
			@gpx.timesCumulated.count.should eq POINTS_COUNT
		end
		
		it "last point cumulated time should not be nil" do
			@gpx.timesCumulated.last.should_not eq nil
		end
		
	end
	
	it "return exeption for non-existing file" do
		expect {
			gpx = GPX::GPX.new 'spec/assets/some_filt_that_not_exists_25363.gpx'
		}.to raise_error( GPX::GPXInvalidFileException )
	end
	
	it "return zero exeption for wrong file type" do
		expect {
			gpx = GPX::GPX.new 'spec/assets/blank.gif'
		}.to raise_error( GPX::GPXInvalidFileException )
	end
	
	it "return exeption for blank file" do
		expect {
			gpx = GPX::GPX.new 'spec/assets/blank.gpx'
		}.to raise_error( GPX::GPXInvalidFileException )
	end
	
	it "should return zero points for file with no track point" do
		gpx = GPX::GPX.new 'spec/assets/empty.gpx'
		gpx.pointsCount.should eq(0)
	end
	
end