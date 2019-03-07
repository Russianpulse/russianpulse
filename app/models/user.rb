class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  acts_as_follower
  has_many :comments
  validates :name, presence: true

  after_create -> { SetUserCountryJob.perform_later(self) }
  after_save -> { SetUserCountryJob.perform_later(self) if saved_change_to_attribute?(:current_sign_in_ip) }

  def admin?
    role == 'admin'
  end
end
