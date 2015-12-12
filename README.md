# ConfidentialInfoManager
[![Build Status](https://travis-ci.org/tatsu07/confidential_info_manager.svg?branch=master)](https://travis-ci.org/tatsu07/confidential_info_manager)

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/confidential_info_manager`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'confidential_info_manager'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install confidential_info_manager

## Usage

### Use as an object

```ruby
require "confidential_info_manager"

raw_data = "string"

manager = ConfidentialInfoManager::Core.new("password")
# encrypt
encrypt_data = manager.encrypt(raw_data)
# decrypt
decrypt_data = manager.decrypt(encrypt_data, String)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/confidential_info_manager. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

