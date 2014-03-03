class Coupon
  include Mongoid::Document
  include Mongoid::Timestamps

  field :code, type: String
  field :description, type: String

  has_many :coupon_users
  belongs_to :to_plan, class_name: "Plan"

  def users
    User.in(id: coupon_users.map(&:user_id))
  end

  def invite(user)
    CouponUser.find_or_create(coupon_id: self.id, user_id: user.id)
  end
end
