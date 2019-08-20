class Comment < ActiveRecord::Base
    belongs_to :user # adds new methods to comment objects for me eg .user
end
