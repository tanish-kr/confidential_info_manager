# ConfidentialInfoManager

[![Join the chat at https://gitter.im/tatsu07/confidential_info_manager](https://badges.gitter.im/tatsu07/confidential_info_manager.svg)](https://gitter.im/tatsu07/confidential_info_manager?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)
[![Build Status](https://travis-ci.org/tatsu07/confidential_info_manager.svg?branch=master)](https://travis-ci.org/tatsu07/confidential_info_manager)
[![Coverage Status](https://coveralls.io/repos/tatsu07/confidential_info_manager/badge.svg?branch=master&service=github)](https://coveralls.io/github/tatsu07/confidential_info_manager?branch=master)

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/confidential_info_manager`. To experiment with that code, run `bin/console` for an interactive prompt.

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

Please the password and the salt used in the encrypter and decrypter passing the same thing at the time of instance generation

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

### Save to YAML, load to YAML

```ruby
require "confidential_info_manager"

password = "password"
file_path = "/tmp"
secret_data = { API_KEY: "abcedefg", API_SECRET_KEY: "abcedfg" }

confidential_info_manager = ConfidentialInfoManager::YAML.new(pass)
confidential_info_manager.save(secret_data, file_path)
yaml_data = confidential_info_manager.load(file_path)

```

## Command line exchange

### Command encrypt

```console
$ echo <raw_data> | openssl enc -e -aes-256-cbc -base64 -pass pass:<password>
```

### Use library for decrypt

```ruby
require "confidential_info_manager"

# Specify the algorithm used. Iterator is 1 fixed
manager = ConfidentialInfoManager::Core.new("password", "AES-256-CBC", 1)
manager.decrypt(cli_encrypt_str)
```

### Use library for encrypt

```ruby
require "confidential_info_manager"

raw_data = "Hello, World"

# Iterator is 1 fixed
manager = ConfidentialInfoManager::Core.new("password", "AES-256-CBC", 1)
manager.encrypt(raw_data)
```

### Command decrypt

```console
# Specify the algorithm used.
$ echo <encrypted_data> | openssl enc -d -aes-256-cbc -base64 -pass pass:<password>
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/confidential_info_manager. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

