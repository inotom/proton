class WorktimesController < ApplicationController
  before_action :signed_in_user

  def create
    @work = current_user.works.find_by(id: worktime_params[:work_id])
    @worktime = @work.worktimes.build(worktime_params)
    @worktime.start_time = Time.new
    @worktime.user_id = current_user.id
    if @worktime.save
      flash[:success] = 'Start work!'
      redirect_to work_path(@work)
    else
      render 'works/show'
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

    def worktime_params
      params.require(:worktime).permit(:work_id,
                                       :start_time,
                                       :memo,
                                       :end_time)
    end
end
