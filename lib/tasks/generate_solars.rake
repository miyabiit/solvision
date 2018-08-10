namespace :setup do
  desc '過去2年分を対象に発電量取得'
  task :generate_solars => :environment do
    target_date = Date.today.beginning_of_month
    date = target_date.ago(2.years).beginning_of_year
    while date < target_date
      FetchSolarsJob.perform_now(date.to_s(:db))
      date = date.next_month
    end
  end
end
