class OrderersController < ApplicationController
  before_action :signed_in_user
  before_action :correct_user, only: [:destroy]

  def index
    @orderers = current_user.orderers
    @orderer = current_user.orderers.build if signed_in?
  end

  def new
  end

  def create
    @orderer = current_user.orderers.build(orderer_params)
    if @orderer.save
      flash[:success] = 'Orderer created!'
      redirect_to orderers_path
    else
      @orderers = current_user.orderers
      render 'orderers/index'
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
