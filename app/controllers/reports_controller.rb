# frozen_string_literal: true

class ReportsController < ApplicationController
  # TODO: implement report generation endpoint - it should delegate to ReportGenerator

  def get
    # I'd find employee first here, maybe id is wrong
    # kinda Employee.find(employee_id)
    # and rescue ActiveRecord::RecordNotFound

    # Hack instead of Employee.find or validating that employee_id is an "integer"
    raise ::Errors::ReportError if Event.where(id: params[:employee_id]).none?

    data = ReportGenerator.new(employee_id: params[:employee_id],
                               from: params[:from],
                               to: params[:to]).call

    render json: data
  end
end
