require 'spec_helper'

describe GPX do

	describe "file with one point" do
		before do
			@gpx = GPX::GPX.new 'spec/assets/one_point.gpx'
		end

		subject { @gpx }

		it { should respond_to :points }
		it { should_not respond_to :points= }

		it { should respond_to :points_count }
		it { should_not respond_to :points_count= }

		it { should_not respond_to :elevations }
		it { should_not respond_to :elevations= }

		it { should respond_to :times }
		it { should_not respond_to :times= }

		it { should respond_to :duration }
		it { should_not respond_to :duration= }

		it { should respond_to :speeds }
		it { should_not respond_to :speeds= }

		it { should respond_to :distances }
		it { should_not respond_to :distances= }

		it { should respond_to :length }
		it { should_not respond_to :length= }

		it { should_not respond_to :times_cumulated }
		it { should_not respond_to :times_cumulated= }

		it { should_not respond_to :distances_cumulated }
		it { should_not respond_to :distances_cumulated= }

		it { should respond_to :average_speed }
		it { should_not respond_to :average_speed= }

		it { should respond_to :max_speed }
		it { should_not respond_to :max_speed= }

		it { should respond_to :start_date }
		it { should_not respond_to :start_date= }

		it { should respond_to :end_date }
		it { should_not respond_to :end_date= }

		it "should return one point" do
			@gpx.points_count.should eq 1
		end

		it "should return point time" do
			@gpx.times.first[:dt].should eq 0
		end

		it "should return point cumulated time" do
			@gpx.times.first[:t].should eq 0
		end

		it "average speed should be zero" do
			@gpx.average_speed.should eq 0
		end

		it "max speed should be zero" do
			@gpx.max_speed.should eq 0
		end

		it "start date should not be nil" do
			@gpx.start_date.should_not eq nil
		end

		it "start date should equals end date" do
			@gpx.start_date.should eq @gpx.end_date
		end

		describe "should return one zero distance (because of one point)" do
			it "distances count should equals one" do
				@gpx.distances.count.should eq 1
			end
			it "first distance should be zero" do
				@gpx.distances.first[:ds].should eq 0
			end
			it "first cumulated distance should be zero" do
				@gpx.distances.first[:s].should eq 0
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

		it "should have proper latitude" do
			@gpx.points.first.latitude.should eq 47.644548
		end
	end

	describe "file with more than one track point" do
		POINTS_COUNT = 6

		before do
			@gpx = GPX::GPX.new 'spec/assets/two_tracks.gpx'
		end

		subject { @gpx }

		it "should return all points in one array" do
			@gpx.points_count.should eq POINTS_COUNT
		end

		it "last point should not be nil" do
			@gpx.points.last.should_not eq nil
		end

		it "should return same count of distances elements as points" do
			@gpx.distances.count.should eq POINTS_COUNT
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

		it "last point cumulated time should be positive" do
			@gpx.times.last[:t].should > 0
		end

		it "last point distance should not be zero" do
			@gpx.distances.last[:ds].should_not eq 0
		end

		it "last point cumulated distance should not be zero" do
			@gpx.distances.last[:s].should_not eq 0
		end

		it "cumulated time should equals duration" do
			@gpx.times.last[:t].should eq @gpx.duration
		end

		it "cumulated distance should equals track length" do
			@gpx.distances.last[:s].should eq @gpx.length
		end

		it "average speed should be positive" do
			@gpx.average_speed.should > 0
		end

		it "max speed should be positive" do
			@gpx.max_speed.should > 0
		end

		it "start date should not equals end date" do
			@gpx.start_date.should_not eq @gpx.end_date
		end
	end

	it "return exeption for non-existing file" do
		expect {
			GPX::GPX.new 'spec/assets/some_filt_that_not_exists_25363.gpx'
		}.to raise_error( GPX::GPXInvalidFileException )
	end

	let(:wrong_file_type_gpx) {GPX::GPX.new 'spec/assets/blank.gif'}
	it "return no points for wrong file type" do
		wrong_file_type_gpx.points_count.should eq 0
	end

	let(:blank_file_gpx) {GPX::GPX.new 'spec/assets/blank.gpx'}
	it "return no points for blank file" do
		blank_file_gpx.points_count.should eq 0
	end

	it "should return zero points for file with no track point" do
		gpx = GPX::GPX.new 'spec/assets/empty.gpx'
		gpx.points_count.should eq(0)
	end

end