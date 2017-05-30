class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  acts_as_follower
  has_many :comments
  validates :name, presence: true

  after_save -> { SetUserCountryJob.perform_later(self) }

  def admin?
    role == 'admin'
  end
end
