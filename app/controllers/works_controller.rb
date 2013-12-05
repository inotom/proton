class WorksController < ApplicationController
  before_action :signed_in_user

  def show
  end

  def new
    @work = Work.new
  end

  def create
    @work = current_user.works.build(work_params)
    if @work.save
      flash[:success] = "Work created!"
      redirect_to current_user
    else
      render 'new'
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

    def work_params
      params.require(:work).permit(:title, :payment, :other, :finished,
                                   :claimed, :receipted, :orderer_id)
    end
end
