# frozen_string_literal: true

class EventsController < ApplicationController
  # TODO: implement the event saving endpoint
  def save
    event = Event.new(employee_id: event_params[:employee_id],
                      timestamp: Time.at(event_params[:timestamp].to_i),
                      kind: event_params[:kind])
    event.save!

    render nothing: true, status: :ok
  end

  private

  # For easiar required params validation
  def event_params
    params.permit(:employee_id, :timestamp, :kind)
  end
end
