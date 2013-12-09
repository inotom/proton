class StaticPagesController < ApplicationController
  def home
    @search_form = SearchForm.new params[:search_form]
    @user = current_user if signed_in?
    @works = current_user.works.paginate(page: params[:page]) if signed_in?
    if @search_form.q.present?
      @works = current_user.works.paginate(page: params[:page])
                 .titled @search_form.q if signed_in?
    end
    @orderers = current_user.orderers if signed_in?
  end

  def help
  end

  def about
  end
end
