require 'open-uri'

class Sale < ActiveRecord::Base
  validates :cause_royalty_percentage, :author_royalty_percentage, :author_royalties, :cause_royalties, :royalty_days_hold, :publisher_royalties, :author_username, :purchase_uuid, :invoice_id, :date_purchased, presence: true
  validates :author_username, uniqueness: { scope: :purchase_uuid }

  def self.save_data_from_leanpub(slug)
    hash_array = fetch_sale_data(slug)
    save_records_from_hash_array!(hash_array)
  end

  def self.fetch_sale_data(slug, page = 1)
    url = "https://leanpub.com/#{slug}/individual_purchases.json?api_key=#{Settings.api_key}"
    JSON.load(open(url))
  end

  def self.save_records_from_hash_array!(hash_array)
    records = []
    self.transaction do
      hash_array.each do |hash|
        sale = find_or_initialize_by(purchase_uuid: hash['purchase_uuid'], author_username: hash['author_username'])
        hash.each do |key, value|
          sale.send("#{key}=", value)
        end
        sale.save!
        records << sale
      end
    end
    records
  end
end
