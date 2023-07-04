# frozen_string_literal: true

class ReportGenerator
  # TODO: - fetch range of events and generate Report
  attr_reader :from, :to, :employee_id, :worktime_hrs, :problematic_dates
  def initialize(employee_id:, from:, to:)
    @employee_id = employee_id
    @from = from
    @to = to
    @worktime_hrs = 0
    @problematic_dates = []
  end

  def call
    # I'd do this with plain sql
    # TODO: handle few ins and outs in one day
    # TODO: handle situation: :in, no :out, than again :in and :out in one day

    data = Event.where(employee_id: employee_id)
                .where('date(timestamp) >= date(:from) AND date(timestamp) <= date(:to)',
                       from: from,
                       to: to)
                .group_by { |e| e.timestamp.to_date }

    data.each do |date, date_data|
      process_date(date: date,
                   date_data: date_data)
    end

    Report.new(worktime_hrs: worktime_hrs,
               problematic_dates: problematic_dates,
               employee_id: employee_id,
               from: from,
               to: to)
          .call
  rescue Exception => e
    raise ::Errors::ReportError, e.message
  end

  private

  def process_date(date:, date_data:)
    in_and_outs = date_data.map(&:kind).uniq

    # in_and_outs.include?(::Event::IN) && in_and_outs.include?(::Event::OUT)
    if in_and_outs.size == 2
      in_time = date_data.detect { |d| d.in? }.timestamp
      out_time = date_data.detect { |d| d.out? }.timestamp

      if out_time < in_time
        @problematic_dates << date
      else
        @worktime_hrs += (out_time - in_time)
      end
    else
      @problematic_dates << date
    end
  end
end
