Sequel.migration do
  up do
    add_column :newsstand_issues, :tsv, 'TSVector'
    add_index :newsstand_issues, :tsv, type: "GIN"
    create_trigger :newsstand_issues, :tsv, :tsvector_update_trigger,
      args: [:tsv, :'pg_catalog.english', :title, :summary],
      events: [:insert, :update],
      each_row: true
  end

  down do
    drop_column :newsstand_issues, :tsv
    drop_index :newsstand_issues, :tsv
    drop_trigger :newsstand_issues, :tsv
  end
end
