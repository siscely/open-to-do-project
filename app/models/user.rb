class User < ActiveRecord::Base
    has_many :lists
    
  validates :name, presence: true
 
  validates :password, presence: true
 
    
    def serialize
        hash = {}
        attributes.each{ |key, val| hash[key] = val }
        hash
    end
end
