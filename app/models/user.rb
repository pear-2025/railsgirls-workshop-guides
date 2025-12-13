class User < ApplicationRecord
  # Use username for authentication instead of email
    devise :database_authenticatable, :registerable,
      :rememberable, :validatable, authentication_keys: [:username]

  validates :username, presence: true, uniqueness: { case_sensitive: false }

  has_many :ideas, dependent: :destroy

  # Devise helpers: make email optional
  def email_required?
    false
  end

  def will_save_change_to_email?
    false
  end
end
