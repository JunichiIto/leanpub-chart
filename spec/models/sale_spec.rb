require 'rails_helper'

RSpec.describe Sale, type: :model do
  describe '::save_records_from_hash_array!' do
    let(:json_text) do
      <<-'JSON'
[
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
]
      JSON
    end

    it 'creates record' do
      sales = Sale.save_records_from_hash_array!(JSON.parse(json_text))
      expect(sales.size).to eq 1
      sale = sales.first
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

      # ついでにレポートもテスト
      rows = Sale.sum_by_date
      expect(rows.size).to eq 1
      row = rows.first
      expect(row).to eq({
          purchased_on: '2016/04/22',
          purchase_count: 1,
          royalties: 1.5,
          cum_royalties: 1.5
                        })
    end
  end

  describe '::filter_by_date_purchased' do
    let(:load_until) { '2016/04/25 00:00'.in_time_zone }
    it 'filters and returns go next or not' do
      data = [
          { 'date_purchased' => '2016-04-26T16:00:00.000Z' }, # 04/27 01:00am(JST)
          { 'date_purchased' => '2016-04-25T17:00:00.000Z' }, # 04/26 02:00am(JST)
      ]
      filtered_data, go_next = Sale.filter_by_date_purchased(data, load_until)
      expect(filtered_data.size).to eq 2
      expect(go_next).to be_truthy

      data = [
          { 'date_purchased' => '2016-04-24T15:00:00.000Z' }, # 04/25 00:00am(JST)
          { 'date_purchased' => '2016-04-24T14:59:59.000Z' }, # 04/24 11:59pm(JST)
      ]
      filtered_data, go_next = Sale.filter_by_date_purchased(data, load_until)
      expect(filtered_data.size).to eq 1
      expect(filtered_data.first).to eq({ 'date_purchased' => '2016-04-24T15:00:00.000Z' })
      expect(go_next).to be_falsey
    end
  end
end
