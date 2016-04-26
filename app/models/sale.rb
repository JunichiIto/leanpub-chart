require 'open-uri'

class Sale < ActiveRecord::Base
  validates :cause_royalty_percentage, :author_royalty_percentage, :author_royalties, :cause_royalties, :royalty_days_hold, :publisher_royalties, :author_username, :purchase_uuid, :invoice_id, :date_purchased, presence: true
  validates :author_username, uniqueness: { scope: :purchase_uuid }

  class << Sale
    def save_data_from_leanpub(slug, load_until: 1.week.ago)
      page = 1
      go_next = true
      self.transaction do
        while go_next
          hash_array = fetch_sale_data(slug, page)
          filtered_data, go_next = filter_by_date_purchased(hash_array, load_until)
          save_records_from_hash_array!(filtered_data)
          page += 1
        end
      end
    end

    def fetch_sale_data(slug, page = 1)
      logger.info "[INFO] Fetching page #{page}"
      url = "https://leanpub.com/#{slug}/individual_purchases.json?api_key=#{Settings.api_key}&page=#{page}"
      JSON.load(open(url))
    end

    def save_records_from_hash_array!(hash_array)
      records = []
      self.transaction do
        hash_array.each do |hash|
          purchase_uuid, author_username = hash.values_at('purchase_uuid', 'author_username')
          logger.info "[INFO] Saving #{purchase_uuid} / #{author_username}"
          sale = find_or_initialize_by(purchase_uuid: purchase_uuid, author_username: author_username)
          hash.each do |key, value|
            sale.send("#{key}=", value)
          end
          sale.save!
          records << sale
        end
      end
      records
    end

    def filter_by_date_purchased(hash_array, load_until)
      filtered_data = []
      go_next = true
      hash_array.each do |hash|
        date_purchased = hash['date_purchased'].to_time
        if load_until <= date_purchased
          filtered_data << hash
        else
          go_next = false
          break
        end
      end
      [filtered_data, go_next]
    end
  end
end
