class StatsController < ApplicationController

  def index
  end
  
  def topUrls
    viewsUrl = UrlLogs.group_and_count(:created_at, :url).where("created_at > ?", 5.days.ago).order(Sequel.desc(:count))
    render :json => custom_json_for(viewsUrl)
  end

  def topReferrers
    viewsUrl = UrlLogs.group_and_count(:created_at, :url)
                  .where("created_at > ?", 5.days.ago)
                  .order(Sequel.desc(:count))
                  .limit(10)
                  
    data = viewsUrl.map do |log|
	
    	topRefs = UrlLogs.select(:url).group_and_count(:referrer)
    	  			.where("created_at = ?", log.created_at)
    	  			.where("url = ?", log.url)
    	  			.order(Sequel.desc(:count))
    	  			.limit(5)

    	referrers = topRefs.map do |ref|
			var = {:url => ref.url, :visits => ref[:count]}
			puts var
		end
		puts referrers
		{log.created_at => 
				[{
					:url => log.url,
					:visits => log[:count],
					:referrer =>
					 [referrers]
				}]
			}
		
    end
                  
    render :json => data.to_json
  end
  
  private
  def custom_json_for(value)
    data = value.map do |log|
      {log.created_at => [{:url => log.url, :visits => log[:count]}]}
    end
    data.to_json
  end
end
