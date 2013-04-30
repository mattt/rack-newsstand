require 'bundler'
Bundler.require

run Rack::Newsstand

# Seed data if no records currently exist
if Rack::Newsstand::Issue.count == 0
  issue = Rack::Newsstand::Issue.create(name: "magazine-0", title: "Magazine 0", published_at: Time.now, cover_urls: {"SOURCE" => "http://example.com/"}, asset_urls: ["http://example.com/"])
end
