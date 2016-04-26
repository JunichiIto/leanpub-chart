class Sale < ActiveRecord::Base
  validates :cause_royalty_percentage, :author_royalty_percentage, :author_royalties, :cause_royalties, :royalty_days_hold, :publisher_royalties, :author_username, :purchase_uuid, :invoice_id, :date_purchased, presence: true
  validates :author_username, uniqueness: { scope: :purchase_uuid }

  def self.create_from_json_text!(json_text)
    hash = JSON.parse(json_text)
    sale = self.new
    hash.each do |key, value|
      sale.send("#{key}=", value)
    end
    sale.save!
    sale
  end
end
