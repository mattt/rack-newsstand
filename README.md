# Rack::Newsstand

> Newsstand was deprecated in iOS 9.
> This project is no longer maintained.

Newsstand was introduced in iOS 5 to give publishers a common framework to syndicate content. `Rack::Newsstand` provides web service endpoints for issue data, as well as a Newsstand Atom feed.

## Requirements

- PostgreSQL 9.1

## Example Usage

Rack::Newsstand can be run as Rack middleware or as a single web application. All that is required is a connection to a Postgres database.

### Gemfile

```ruby
source "https://rubygems.org"

gem 'rack-newsstand'
gem 'pg'
```

### config.ru

```ruby
require 'bundler'
Bundler.require

run Rack::Newsstand
```

An example application can be found in the `/example` directory of this repository.

### `GET /issues` (`Accept: application/x-plist`)

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <array>
    <dict>
      <key>name</key>
      <string>magazine-1</string>
      <key>title</key>
      <string>Magazine Issue 1</string>
      <key>summary</key>
      <string>Lorem ipsum dolar sit amet</string>
      <key>date</key>
      <date>2013-04-19T12:00:00Z</date>
      <key>covers</key>
      <dict>
        <key>SOURCE</key>
        <string>http://example.com/assets/covers/magazine-1.png</string>
      </dict>
      <key>content</key>
      <array>
        <string>http://example.com/assets/content/magazine-1.pdf</string>
      </array>
    </dict>
  </array>
</plist>
```

### `GET /issues` (`Accept: application/application/atom+xml`)

```xml
<?xml version="1.1" encoding="UTF-8"?>
<feed xmlns="http://www.w3.org/2005/Atom" xmlns:news="http://itunes.apple.com/2011/Newsstand">
  <updated>
  </updated>
  <entry>
    <id>magazine-0</id>
    <summary/>
    <updated>2013-04-30 09:59:54 -0700</updated>
    <published>2013-04-30 09:59:54 -0700</published>
    <news:cover_art_icons>
      <news:cover_art_icon size="SOURCE" src="http://example.com/assets/covers/magazine-1.png"/>
    </news:cover_art_icons>
  </entry>
</feed>
```

## Contact

[Mattt](https://twitter.com/mattt)

## License

Rack::Newsstand is available under the MIT license.
See the LICENSE file for more info.
