class StatsController < ApplicationController

  def index
  end
  
  def topUrls
    viewsUrl = UrlLogs.group_and_count(:created_at, :url).where("created_at > ?", 5.days.ago).order(Sequel.desc(:created_at))
    data = viewsUrl.inject({}) do |h,log| 
    	h[log.created_at] ||= [] #define if nil
    	h[log.created_at] << [{:url => log.url}, :visits => log[:count]] #append new value
    	h # object we are building
    end
    render :json => data.to_json
  end

  def topReferrers
    viewsUrl = UrlLogs.group_and_count(:created_at, :url)
                  .where("created_at > ?", 5.days.ago)
                  .order(Sequel.desc(:count))
                  .limit(10)
           
    data = viewsUrl.inject({}) do |h,log|
    	
    	topRefs = UrlLogs.group_and_count(:referrer)
    	  			.where("created_at = ?", log.created_at)
    	  			.where("url = ?", log.url)
    	  			.order(Sequel.desc(:count))
    	  			.limit(5)
    	  			
    	h[log.created_at] ||= [] #define if nil
    	h[log.created_at] << [{:url => log.url}, :visits => log[:count], :referrer => []] #append new value
    	h # object we are building
    	
		topRefs.map do |ref|
 			h[log.created_at][0] << {:url => ref.referrer, :visits => ref[:count]}
 		end
		
	# 	{log.created_at => 
# 				[{
# 					:url => log.url,
# 					:visits => log[:count],
# 					:referrer =>
# 					 [referrers]
# 				}]
# 			}
      end     
    render :json => data.to_json
  end
end
