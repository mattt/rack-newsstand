require 'plist'

module Rack
  class Newsstand
    class Issue < Sequel::Model
      plugin :json_serializer, naked: true, except: :id
      plugin :validation_helpers
      plugin :timestamps, force: true, update_on_create: true
      plugin :schema
      plugin :typecast_on_load

      self.dataset = :newsstand_issues
      self.strict_param_setting = false
      self.raise_on_save_failure = false

      def to_plist_node
        {
          name: self.name,
          title: self.title,
          date: self.published_at,
          covers: (self.cover_urls || {}).to_hash,
          assets: (self.asset_urls || []).to_a
        }.to_plist(false)
      end

      def validate
        super

        validates_presence [:name, :published_at]
        validates_unique :name
      end
    end
  end
end
