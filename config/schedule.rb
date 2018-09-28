# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

env :DISABLE_SPRING, "1"
set :output, 'log/crontab.log'

every :day, at: "4:00 am" do
  runner "FetchSolarsJob.perform_now"
end

every :day, at: "1:00 pm" do
  runner "FetchJmaDataJob.perform_now"
end

# Learn more: http://github.com/javan/whenever
