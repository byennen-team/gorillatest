class CouponUser
  include Mongoid::Document
  include Mongoid::Timestamps

  field :used_at, type: DateTime

  belongs_to :user
  belongs_to :coupon

  after_create :send_coupon_email

  private

  def send_coupon_email
    UserMailer.send_coupon_email(self.coupon_id, self.user_id).deliver
  end
end
