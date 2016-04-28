class VisitorsController < ApplicationController
  def index
    @sales = Sale.sum_by_date
  end
end
