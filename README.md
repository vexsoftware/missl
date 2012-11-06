# MISSL

**M**ake **I**mages **SSL** is a simple image proxy based on Sinatra. MISSL performs basic filtering to limit content type to images, and content length to 5MB. Local IP addresses are also restricted.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'missl', :git => 'git://github.com/vexsoftware/missl.git'
```

And then execute:

```bash
$ bundle
```

If you are using Rails, add this line to your routes file:

```ruby
mount Missl::Base => "/missl", :as => :missl
```

## Usage

To proxy a non-SSL image on Rails, use the following for the image URL:
```ruby
missl_path(:url => "http://example.com/path/to/image.png")
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

Copyright (c) 2012 Vex Software LLC, released under the MIT license.