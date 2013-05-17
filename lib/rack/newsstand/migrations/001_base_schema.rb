Sequel.migration do
  up do
    run %{CREATE EXTENSION IF NOT EXISTS hstore;}

    create_table :newsstand_issues do
      primary_key :id

      column :name,         :varchar, unique: true, empty: false
      column :summary,      :varchar, empty: false
      column :tags,         :'text[]'
      column :metadata,     :hstore
      column :cover_urls,   :hstore
      column :asset_urls,   :'text[]'
      column :created_at,   :timestamp
      column :updated_at,   :timestamp
      column :published_at, :timestamp
      column :expires_at,   :timestamp

      index :name
      index :published_at
    end
  end

  down do
    drop_table :newsstand_issues
  end
end
