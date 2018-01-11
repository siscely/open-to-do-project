class User < ActiveRecord::Base
    has_many :lists
    
    def serialize
        hash = {}
        attributes.each{ |key, val| hash[key] = val }
        hash
    end
end
