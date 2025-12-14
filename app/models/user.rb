class User < ApplicationRecord
  # Use username for authentication instead of email
    devise :database_authenticatable, :registerable,
      :rememberable, :validatable, authentication_keys: [:username]

  validates :username, presence: true, uniqueness: { case_sensitive: false }

  has_many :ideas, dependent: :destroy
  has_many :work_logs, dependent: :destroy
  mount_uploader :avatar, PictureUploader

  # Score based on submitted ideas. Each submitted idea gives base 1 point.
  # If submitted before the deadline (`idea.date`), add 1 point per day early.
  def submission_score
    ideas.where(submission: 1).sum do |i|
      if i.date.present? && i.updated_at.present?
        days_early = (i.date - i.updated_at.to_date).to_i
        1 + [days_early, 0].max
      else
        1
      end
    end
  end

  def level
    # Level formula: base level 1 + floor(score / 5)
    1 + (submission_score / 5)
  end

  def score_in_current_level
    submission_score % 5
  end

  def points_to_next_level
    rem = score_in_current_level
    rem == 0 ? 0 : 5 - rem
  end

  def progress_percentage
    (score_in_current_level.to_f / 5.0 * 100).round
  end

  # Devise helpers: make email optional
  def email_required?
    false
  end

  def will_save_change_to_email?
    false
  end
end
