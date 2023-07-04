# frozen_string_literal: true

class Report
  include ActiveModel::Validations
  # TODO: represents the actual report, validate data and implement report methods
  attr_reader :worktime_hrs, :problematic_dates, :employee_id, :from, :to

  def initialize(worktime_hrs:, problematic_dates:, employee_id:, from:, to:)
    @employee_id = employee_id
    @from = from
    @to = to
    @worktime_hrs = worktime_hrs
    @problematic_dates = problematic_dates
  end

  def call
    {
      employee_id: employee_id.to_i,
      from: prepare_date(from),
      to: prepare_date(to),
      worktime_hrs: prepare_time(worktime_hrs),
      problematic_dates: problematic_dates.map { |date| prepare_date(date) }
    }
  end

  private

  def prepare_date(date)
    date.to_date.strftime('%Y-%m-%d')
  end

  def prepare_time(time)
    (time / 3600).round(2)
  end
end
