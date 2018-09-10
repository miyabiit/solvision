namespace :setup do
  desc '過去2年分を対象に発電量取得'
  task :generate_solars => :environment do
    target_date = Date.today.beginning_of_month
    date = target_date.ago(2.years).beginning_of_year
    while date <= target_date
      FetchSolarsJob.perform_now(date.to_s(:db))
      date = date.next_month
    end
  end

  desc '過去2年分を対象にJMAスクレイピング'
  task :generate_jma_data => :environment do
    target_date = Date.today.beginning_of_month
    date = target_date.ago(2.years).beginning_of_year
    while date <= target_date
      FetchJmaDataJob.perform_now(date.to_s(:db))
      date = date.next_month
    end
  end

  desc 'NEDOのMONSOLA-11データをインポート'
  task :import_nedo_monsola11 => :environment do
    Rails.root.join('data', 'nedo', 'MONSOLA11m').glob('m*').each do |pathname|
      File.open(pathname, 'r', external_encoding: 'cp932') do |file|
        NedoParser.parse(file.read)
      end
    end
  end
end
