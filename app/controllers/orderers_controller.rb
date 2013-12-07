class OrderersController < ApplicationController
  before_action :signed_in_user
  before_action :correct_user, only: [:edit, :update, :destroy]

  def index
    @orderers = current_user.orderers
  end

  def new
  end

  def create
    @orderer = current_user.orderers.build(orderer_params)
    if @orderer.save
      flash[:success] = 'Orderer created!'
      redirect_to orderers_path
    else
      @orderers = current_user.orderers.reject { |odr| odr.id.nil? }
      render 'orderers/index'
    end
  end

  def edit
  end

  def update
    if @orderer.update_attributes(orderer_params)
      flash[:success] = "Orderer updated!"
      redirect_to orderers_path
    else
      render 'edit'
    end
  end

  def destroy
    @orderer.destroy
    redirect_to orderers_path
  end

  private

    def orderer_params
      params.require(:orderer).permit(:name)
    end

    def correct_user
      @orderer = current_user.orderers.find_by(id: params[:id])
      redirect_to root_url if @orderer.nil?
    end
end
