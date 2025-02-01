class User < ApplicationRecord
  # Relation between friends and users
  has_many :friends, class_name: "Friend", foreign_key: "user_id", dependent: :destroy
  has_many :inverse_friends, class_name: "Friend", foreign_key: "friend_id", dependent: :destroy

  has_many :friends_of_user, through: :friends, source: :friend
  has_many :friends_for_user, through: :inverse_friends, source: :user

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :session_limitable
  # Your model logic here
  has_many :posts
  validates :nombre, :apellido, :username, presence: true

  validate :profile_pic_size

  private

  def profile_pic_size
    if profile_pic.present? && profile_pic.tempfile.size > 2.megabytes
      errors.add(:profile_pic, "should be less than 2MB")
    end
  end
end
