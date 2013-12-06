class StaticPagesController < ApplicationController
  def home
    @user = current_user if signed_in?
    @works = current_user.works.paginate(page: params[:page]) if signed_in?
  end

  def help
  end

  def about
  end
end
