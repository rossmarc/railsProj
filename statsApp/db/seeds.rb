# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

url = ["http://apple.com", "https://apple.com", "https://www.apple.com", "http://developer.apple.com", "http://en.wikipedia.org", "http://opensource.org"]
referrer = ["http://apple.com", "https://apple.com", "https://www.apple.com", "http://developer.apple.com", "NULL"]

0.upto(1000000) do |i|
   UrlLogs.create(
    :url => url[rand(url.length)],
    :referrer => referrer[rand(referrer.length)],
    :created_at =>  (rand*10).days.ago
   )   
end