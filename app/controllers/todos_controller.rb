class TodosController < ApplicationController
  before_action :signed_in_user
  before_action :correct_todo, only: [:update, :destroy]

  def create
    @work = current_user.works.find_by(id: todo_params[:work_id])
    @todo = @work.todos.build(todo_params)
    if @todo.save
      flash[:success] = "Todo created!"
      redirect_to work_path(@work)
    else
      @todos = @work.todos.reject { |todo| todo.id.nil? }
      render 'works/show'
    end
  end

  def update
    @todo.update_attribute(:status, !@todo.status)
    redirect_to work_path(@work)
  end

  def destroy
    @todo.destroy
    redirect_to work_path(@work)
  end

  private

    def todo_params
      params.require(:todo).permit(:work_id, :status, :title)
    end

    def correct_todo
      @todo = Todo.find(params[:id])
      @work = current_user.works.find_by(id: @todo.work_id)
      redirect_to(root_path) if @work.nil?
    end
end
