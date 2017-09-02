class PurchasesController < ApplicationController
  def new
    @purchase = Purchase.new
    @locations = ["Albright Court", "Albright Woods", "Crowell Hall", "Krause Hall", "Moan Hall", "North Hall", "Rockland Hall", "Smith Hall", "Walton Hall"]
  end

  def create
    @purchase = current_user.purchases.build(purchases_params)
    params[:email] = current_user.email
    @purchase.build_stripe_customer(params)
    @purchase.save
    respond_to do |format|
      format.json {render json: {is_success: true}}
    end
  end

  private

    def purchases_params
      params.require(:purchase).permit(:move_out_location, :move_in_location, :move_out_room, :move_in_room, :move_out_date, :move_in_date, :storage_items, :ui_stripe_token)
    end

end
