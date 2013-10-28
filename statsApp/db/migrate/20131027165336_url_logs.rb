Sequel.migration do 
  change do

    create_table :url_logs do
      primary_key :id
      String :url
      String :referrer
      Datetime :created_at
      String :serialized
    end

  end
end