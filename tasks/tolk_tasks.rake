namespace :tolk do
  desc "Sync Tolk with the default locale's yml file"
  task :sync => :environment do
    Tolk::Locale.sync!
  end

  desc "Generate yml files for all the locales defined in Tolk"
  task :dump_all => :environment do
    Tolk::Locale.dump_all
  end

  desc "Imports data all non default locale yml files to Tolk"
  task :import => [:'tolk:sync', :'tolk:import_secondary']

  task :import_secondary => :environment do
    Tolk::Locale.import_secondary_locales
  end
  
  task :delete_secondary => :environment do
    Tolk::Locale.secondary_locales.each do |locale|
      locale.destroy
      puts %(deleted locale "#{locale.name}")
    end
  end

  desc "Show all the keys potentially containing HTML values and no _html postfix"
  task :html_keys => :environment do
    bad_translations = Tolk::Locale.primary_locale.translations_with_html
    bad_translations.each do |bt|
      puts "#{bt.phrase.key} - #{bt.text}"
    end
  end
end
