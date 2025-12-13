class Idea < ApplicationRecord
  belongs_to :user
  has_many :comments
  mount_uploader :picture, PictureUploader

  enum status: { not_started: 0, in_progress: 1, completed: 2 }
end
