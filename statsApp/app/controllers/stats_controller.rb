class StatsController < ApplicationController

  def index
  end
  
  def topUrls
    viewsUrl = UrlLogs.group_and_count(:created_at, :url).where("created_at >= ?", 5.days.ago).order(Sequel.desc(:created_at))
    data = viewsUrl.inject({}) do |h,log| 
    	h[log.created_at] ||= [] #define if nil
    	h[log.created_at] << {:url => log.url, :visits => log[:count]} #append new value
    	h # object we are building
    end
    render :json => data.to_json
  end

  def topReferrers
    viewsUrl = UrlLogs.group_and_count(:created_at, :url)
                  .where("created_at >= ?", 5.days.ago)
                  .having(:count 
                  .order(Sequel.desc(:count))
	h = Hash.new() 
	@ref = Hash.new()   
    viewsUrl.each do |log| 
    
    	topRefs = UrlLogs.group_and_count(:referrer)
    	  			.where("created_at = ?", log.created_at)
    	  			.where("url = ?", log.url)
    	  			.order(Sequel.desc(:count))
    	  			.limit(5)

		topRefs.each do |ref|
			@ref[log.url] ||= []
			@ref[log.url] << {:url => ref.referrer, :visits => ref[:count]}
 		end

 		h[log.created_at] ||= [] #define if nil
    	h[log.created_at] << {:url => log.url,:visits => log[:count],:referrer => @ref[log.url]} #append new value

      end     
    render :json => h.to_json
  end
end
