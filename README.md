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

Sync always:

```ruby
use Rack::Rsync(source, destination, "-a", "--delete")
```

Sync with conditions:

```ruby
use Rack::Rsync(source, destination, "-a", "--delete") do |env|
  env["REQUEST_METHOD"] == "POST"
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/[my-github-username]/rack-rsync/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
