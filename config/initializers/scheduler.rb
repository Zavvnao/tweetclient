#
# config/initializers/scheduler.rb

require 'rufus-scheduler'

# Let's use the rufus-scheduler singleton
#
s = Rufus::Scheduler.singleton


# Stupid recurrent task...
#

s.every '10s' do
	#Rails.logger.info "running scheduler"
	#Tweet.check_for_tweets
end
