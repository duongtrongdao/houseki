class Fooddrink < ActiveRecord::Base
    mount_uploader :file, FooddrinkUploader
    
    belongs_to :user
    
    validates :user, presence: true
    acts_as_commontable
    
    resourcify
end
