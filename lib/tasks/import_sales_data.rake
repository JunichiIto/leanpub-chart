task import_sales_data: :environment do
  Sale.save_data_from_leanpub Settings.target_slug, load_until: Settings.date_from.in_time_zone
end