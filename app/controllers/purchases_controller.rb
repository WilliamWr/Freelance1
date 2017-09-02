class PurchasesController < ApplicationController
  def new
    @purchase = Purchase.new
    @locations = ["Albright Court", "Albright Woods", "Crowell Hall", "Krause Hall", "Moan Hall", "North Hall", "Rockland Hall", "Smith Hall", "Walton Hall"]
  end

  def create
    @purchase = current_user.purchases.build(purchases_params)
    @purchase.build_stripe_customer
    respond_to do |format|
      if @purchase.errors.none? && @purchase.save!
        format.json {render json: { ui_stripe_token: @purchase.stripe_token }}
      else
        format.json {render json: { ui_stripe_token: @purchase.stripe_token, errors: @purchase.errors.full_messages, }}
      end
    end
  end

  private

    def purchases_params
      params.require(:purchase).permit(:move_out_location, :move_in_location,
                                        :move_out_room,
                                        :move_in_room,
                                        :registration_fee_paid,
                                        :registration_fee_paid_date,
                                        :move_out_date,
                                        :move_in_date,
                                        :storage_items,
                                        :ui_stripe_token,
                                        :amount)
    end

end
