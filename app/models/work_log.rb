class WorkLog < ApplicationRecord
  belongs_to :user
  belongs_to :idea, optional: true

  validates :user_id, :work_date, :work_hours, presence: true
  validates :work_hours, numericality: { greater_than: 0 }
end
