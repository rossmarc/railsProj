class CreateUrlStats < ActiveRecord::Migration
  def change
    create_table :url_stats do |t|
      t.string :url
      t.string :referrer
      t.datetime :created_at      
      t.string :serialized
    end
  end
end
