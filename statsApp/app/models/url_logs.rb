class UrlLogs < Sequel::Model
      
  def after_create
  	super
    hash = Digest::MD5.hexdigest(self.id.to_s() + self.url + self.referrer + self.created_at.to_s())
    self.set(:serialized => hash)
    self.save
  end
  
end
