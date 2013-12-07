class WorksController < ApplicationController
  before_action :signed_in_user
  before_action :correct_user, only: [:show, :edit, :update, :destroy]

  def show
    @work = Work.find(params[:id])
    @orderer = current_user.orderers.find_by(id: @work.orderer_id) if signed_in?
  end

  def new
    @work = Work.new
    @orderers = current_user.orderers
  end

  def create
    @work = current_user.works.build(work_params)
    if @work.save
      flash[:success] = "Work created!"
      redirect_to root_path
    else
      render 'new'
    end
  end

  def edit
    @orderers = current_user.orderers
  end

  def update
    if @work.update_attributes(work_params)
      flash[:success] = "Work updated!"
      redirect_to work_path(@work)
    else
      render 'edit'
    end
  end

  def destroy
    @work.destroy
    redirect_to root_path
  end

  private

    def work_params
      params.require(:work).permit(:title, :payment, :other, :finished,
                                   :claimed, :receipted, :orderer_id)
    end

    def correct_user
      @work = current_user.works.find_by(id: params[:id])
      redirect_to(root_path) if @work.nil?
    end
end
