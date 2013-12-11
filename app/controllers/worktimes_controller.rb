class WorktimesController < ApplicationController
  before_action :signed_in_user
  before_action :correct_worktime, only: [:edit, :destroy]

  def create
    @work = current_user.works.find_by(id: worktime_params[:work_id])
    @worktime = @work.worktimes.build(worktime_params)
    @worktime.start_time = Time.now
    if @worktime.save
      flash[:success] = 'Start work!'
      redirect_to work_path(@work)
    else
      @worktimes = @work.worktimes.reject { |wktm| wktm.id.nil? }
      render 'works/show'
    end
  end

  def edit
  end

  def update
    @work = current_user.works.find_by(id: worktime_params[:work_id])
    @worktime = @work.worktimes.find_by(id: params[:id])
    @worktime.end_time = Time.now if params[:mode].nil?
    if @worktime.update_attributes(worktime_params)
      flash[:success] = 'End work!'
      redirect_to work_path(@work)
    else
      render 'works/show'
    end
  end

  def destroy
    @worktime.destroy
    redirect_to work_path(@work)
  end

  private

    def worktime_params
      params.require(:worktime).permit(:work_id,
                                       :start_time,
                                       :memo,
                                       :end_time)
    end

    def correct_worktime
      @worktime = Worktime.find(params[:id])
      @work = current_user.works.find_by(id: @worktime.work_id)
      redirect_to(root_path) if @work.nil?
    end
end
