module ChartHelper
  def goal_data
    goal = Settings.royalty_goal.to_f
    from = Settings.date_from.in_time_zone.ago(1.day)
    to = Settings.date_to.in_time_zone.since(1.day)
    data = []
    current = from
    while current <= to
      data << [current.to_i * 1000, goal]
      current = current + 1.day
    end
    data
  end

  def cum_royalties_data(sales)
    sales.map do |record|
      date = record.purchased_on.in_time_zone.to_i * 1000
      [date, record.cum_royalties.floor(2).to_f]
    end
  end

  def purchase_count_data(sales)
    sales.map do |record|
      date = record.purchased_on.in_time_zone.to_i * 1000
      [date, record.purchase_count]
    end
  end
end