require 'rails_helper'

RSpec.describe Sale, type: :model do
  describe '::create_from_json_text!' do
    let(:json_text) do
      <<-'JSON'
{
   "cause_royalty_percentage":"0.0",
   "author_royalty_percentage":"5.0",
   "author_royalties":"1.5",
   "cause_royalties":"0.0",
   "author_paid_out_at":null,
   "cause_paid_out_at":null,
   "created_at":"2016-04-21T15:58:45.000Z",
   "royalty_days_hold":45,
   "publisher_royalties":"0.0",
   "publisher_paid_out_at":null,
   "author_username":"foo_bar",
   "publisher_slug":"",
   "user_email":"",
   "purchase_uuid":"HlKg4GLtj-fVwM4UqcRj2",
   "invoice_id":"DimXToR5rhc2z_g8A34LM",
   "date_purchased":"2016-04-21T15:58:45.000Z"
}
      JSON
    end
    it 'creates record' do
      sale = Sale.create_from_json_text!(json_text)
      expect(sale).to be_persisted
      expect(sale).to have_attributes(
                          cause_royalty_percentage: BigDecimal('0.0'),
                          author_royalty_percentage: BigDecimal('5.0'),
                          author_royalties: BigDecimal('1.5'),
                          cause_royalties: BigDecimal('0.0'),
                          author_paid_out_at: nil,
                          cause_paid_out_at: nil,
                          royalty_days_hold: 45,
                          publisher_royalties: BigDecimal('0.0'),
                          publisher_paid_out_at: nil,
                          author_username: 'foo_bar',
                          publisher_slug: '',
                          user_email: '',
                          purchase_uuid: 'HlKg4GLtj-fVwM4UqcRj2',
                          invoice_id: 'DimXToR5rhc2z_g8A34LM',
                          date_purchased: '2016-04-21T15:58:45.000Z'.to_time
                      )
      # JSTとして扱われること
      time_text = I18n.l sale.date_purchased
      expect(time_text).to eq '2016/04/22 00:58:45'
    end
  end
end
