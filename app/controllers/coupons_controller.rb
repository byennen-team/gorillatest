class CouponsController < ApplicationController

  before_filter :authenticate_user!

  def redeem
    coupon = current_user.coupons.where(code: params[:coupon_code]).first
    if coupon
      current_user.update_attribute(:plan_id, coupon.to_plan.id)
      redirect_to edit_user_registration_path(anchor: "change-plan"), notice: "Your plan has been successfully changed"
    else
      redirect_to edit_user_registration_path(anchor: "change-plan"), alert: "Invalid coupon code"
    end
  end
end
