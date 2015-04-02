class Tweet < ActiveRecord::Base
	# Set association between User and Tweets
	belongs_to :user, :class_name => "User", :foreign_key => "user_id"

	validates :username, :tweetbody, presence: true
end
