require 'rack'
require 'sinatra/base'
require 'sequel'

module Rack
  class Newsstand < Sinatra::Base
    autoload :Issue, 'rack/newsstand/models/issue'

    disable :raise_errors, :show_exceptions

    configure do
      Sequel.extension :core_extensions, :migration, :pg_array, :pg_hstore, :pg_hstore_ops

      if ENV['DATABASE_URL']
        DB = Sequel.connect(ENV['DATABASE_URL'])
        DB.extend Sequel::Postgres::PGArray::DatabaseMethods
        DB.extend Sequel::Postgres::HStore::DatabaseMethods

        Sequel::Migrator.run(DB, ::File.join(::File.dirname(__FILE__), "newsstand/migrations"), table: 'newsstand_schema_info')
      end
    end

    get '/issues' do
      @issues = Issue.order(:published_at).all

      request.accept.each do |type|
        case type.to_s
        when 'application/atom+xml', 'application/xml', 'text/xml'
          content_type 'application/x-plist'
          return builder :atom
        when 'application/x-plist'
          content_type 'application/x-plist'
          return @issues.to_plist
        when 'application/json'
          pass
        end
      end

      halt 406
    end

    get '/issues/:name' do
      pass unless request.accept? 'application/x-plist'
      content_type 'application/x-plist'

      Issue.find(name: params[:name]).to_plist
    end

    template :atom do
<<-EOF
      xml.instruct! :xml, :version => '1.1'
      xml.feed "xmlns" => "http://www.w3.org/2005/Atom",
               "xmlns:news" => "http://itunes.apple.com/2011/Newsstand" do

      xml.updated { @issues.first.updated_at rescue Time.now }

      @issues.each do |issue|
        xml.entry do
          xml.id issue.name
          xml.summary issue.summary
          xml.updated issue.updated_at
          xml.published issue.published_at
          xml.tag!("news:end_date"){ issue.expires_at } if issue.expires_at
          xml.tag!("news:cover_art_icons") do
            issue.cover_urls.each do |size, url|
              xml.tag!("news:cover_art_icon", size: size, src: url)
            end
          end
        end
      end
    end
EOF
    end
  end
end
