# frozen_string_literal: true

class Event < ApplicationRecord
  # TODO: implement validations and kind of events
  # I'd made kind column of type string
  IN = 'in'.freeze
  OUT = 'out'.freeze

  validates :employee_id, :timestamp, :kind, presence: true
  validates :kind, inclusion: { in: [IN, OUT] } # ???

  enum kind: {
    in: 0,
    out: 1
  }
end
