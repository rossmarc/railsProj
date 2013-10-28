class StatsController < ApplicationController

  def index
  end
  
  def topUrls
    @viewsUrl = UrlLogs.group_and_count(:created_at, :url).where("created_at > ?", 5.days.ago)
    render :json => @viewsUrl
  end

  def topReferrers
    @viewsUrl = UrlLogs.group_and_count(:created_at, :url)
                  .where("created_at > ?", 5.days.ago)
                  .order(Sequel.desc(:count))
                  .limit(10)
                  
    @viewsUrl.each do |log|
    	@topRefs = UrlLogs.group_and_count(:referrer)
    	  			.where("created_at = ?", log.created_at)
    	  			.where("url = ?", log.url)
    	  			.order(Sequel.desc(:count))
    	  			.limit(5)
    end
    
                  
    render :json => @viewsUrl
  end
end
