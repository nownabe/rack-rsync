# Rack::Rsync

[![Gem Version](https://badge.fury.io/rb/rack-rsync.svg)](http://badge.fury.io/rb/rack-rsync)
[![Build Status](https://travis-ci.org/nownabe/rack-rsync.svg)](https://travis-ci.org/nownabe/rack-rsync)

A rack middleware to sync files using rsync.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rack-rsync'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rack-rsync

## Usage

Sync when any request:

```ruby
# config.ru

require "rack/rsync"

use Rack::Rsync, source, destination, "-a", "--delete"

run App
```

Sync with conditions:

```ruby
# config.ru

require "rack/rsync"

use Rack::Rsync, source, destination, "-a", "--delete" do |env|
  env["REQUEST_METHOD"] == "POST"
end

run App
```

## Contributing

1. Fork it ( https://github.com/nownabe/rack-rsync/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
