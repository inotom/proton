class WorksController < ApplicationController
  before_action :signed_in_user
  before_action :correct_user, only: [:show, :edit, :update, :destroy, :worktimeschart]
  before_action :finished_at, only: [:update]

  def show
    @work = Work.find(params[:id])
    @orderer = current_user.orderers.find_by(id: @work.orderer_id) if signed_in?
    @todos = @work.todos
    @todo = @work.todos.build if signed_in?
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
      @orderers = current_user.orderers
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
      @orderers = current_user.orderers
      render 'edit'
    end
  end

  def destroy
    @work.destroy
    redirect_to root_path
  end

  def worktimeschart
    respond_to do |format|
      format.json { render :json => { status: 'success',
                                      id: @work.id,
                                      chart: @work.worktimes_chart }.to_json }
    end
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

    ##
    # set datetime to @work.finished_at only once
    #
    # work_params[:finished]
    # "0" : unchecked
    # "1" : checked
    def finished_at
      @work.update_attribute(:finished_at, Time.now) if @work.finished_at.nil? && work_params[:finished] == "1"
    end
end
