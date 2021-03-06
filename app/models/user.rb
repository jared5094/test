class User < ActiveRecord::Base

  has_many :habits
  validates :name, length: {minimum: 2}

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def last_habit
    habits.last
  end
end
