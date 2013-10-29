class StatsController < ApplicationController

  def index
  end
  
  def topUrls
    viewsUrl = UrlLogs.group_and_count(:created_at, :url).where("created_at >= ?", 5.days.ago).order(Sequel.desc(:created_at))
    h = Hash.new() 
    viewsUrl.each do |log| 
    	h[log.created_at] ||= [] #define if nil
    	h[log.created_at] << {:url => log.url, :visits => log[:count]} #append new value
    end
    render :json => h.to_json
  end

  def topReferrers
  	h = Hash.new() 
	query = "SELECT `created_at`, `url`, count(*) AS `count` FROM `url_logs` 
			 WHERE (created_at >= '"+5.days.ago.to_s+"')
			 GROUP BY `created_at`, `url` ORDER BY `created_at` DESC, `count` DESC"
				
	viewsUrl = UrlLogs.db().fetch("
			SELECT * FROM ("+query+") AS t1
			where (
	   		SELECT COUNT(*) FROM ("+query+") as u
			where u.created_at = t1.created_at and u.url <= t1.url
			) <= 4;
		")
	
    viewsUrl.each do |log| 
    	topRefs = UrlLogs.group_and_count(:referrer)
    	  			.where("created_at = ?", log[:created_at])
    	  			.where("url = ?", log[:url])
    	  			.order(Sequel.desc(:count))
    	  			.limit(5)
    	
    	@ref = Hash.new()	
		topRefs.each do |ref|
			@ref[log[:url]] ||= []
			@ref[log[:url]] << {:url => ref.referrer, :visits => ref[:count]}
 		end

 		h[log[:created_at]] ||= [] #define if nil
    	h[log[:created_at]] << {:url => log[:url],:visits => log[:count],:referrer => @ref[log[:url]]} #append new value
    end
    render :json => h.to_json
  end
end
