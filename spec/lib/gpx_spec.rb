require 'spec_helper'

describe GPX do
	
	describe "respond to" do
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
		
		it "should return one point for file with one track point" do
			@gpx.pointsCount.should eq(1)
		end
		
		it "should return one elevation point for file with one track point" do
			@gpx.elevations.count.should eq(1)
		end
		
		it "should return point time for file with one track point" do
			@gpx.times[0].should eq Time.parse('2009-10-17 18:37:26 UTC')
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