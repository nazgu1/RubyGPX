# GPX gem

Gem that helps parsing and calculating stats form GPX files.

![Build status](https://magnum-ci.com/status/c944b4356269a42f413d73ca59820230.png)

## Installation

Add this line to your application's Gemfile:

    gem 'gpx'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install gpx

## Usage

    require 'gpx'
    
    gpx = GPX.new 'path_to_GPX_file'
    
    gpx.points_count    # get count of track points
    
    gpx.duration        # get track duration [s]
    gpx.length          # get track length [km]
    
    gpx.times[n][:t]    # get time delta for n-th and n-1-th track point
    gpx.times[n][:dt]   # get time delta for n-th and n-1-th track point
    
    gpx.distances[n][:s]    # get distance between track start and n-th track point
    gpx.distances[n][:ds]   # get distance delta for track n-th and n-1-th track point
    
    gpx.max_speed       # get max value from all partial speeds (ds/dt)
    gpx.average_speed   # get average speed for track
    
    gpx.speeds          # get partial speeds
    
    gpx.start_date      # date when track begins
    gpx.end_date        # date when track ends

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
