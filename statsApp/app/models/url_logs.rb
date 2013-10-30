class UrlLogs < Sequel::Model
      
  def after_create
  	super
  	if (self.referrer != 'NULL') 
    	hash = Digest::MD5.hexdigest(self.id.to_s() + self.url + self.referrer + self.created_at.to_s())
    else
    	hash = Digest::MD5.hexdigest(self.id.to_s() + self.url + self.created_at.to_s())
    end
    self.set(:serialized => hash)
    self.save
  end

end
