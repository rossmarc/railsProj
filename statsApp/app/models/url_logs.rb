class UrlLogs < Sequel::Model
  
  after_save :update_hash
    
  def update_hash
    hash = Digest::MD5.hexdigest(self.id.to_s() + self.url + self.referrer + self.created_at.to_s())
    self.update_column(:serialized, hash)
  end
  
end
