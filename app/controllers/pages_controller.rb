class PagesController < ApplicationController
  def about
    # prepare calendar data: month param optional (format: YYYY-MM-DD or YYYY-MM)
    @month = params[:month].present? ? Date.parse(params[:month]) : Date.current

    if user_signed_in?
      ideas = current_user.ideas.where.not(date: nil)
      @ideas_by_date = ideas.group_by { |i| i.date }
    else
      @ideas_by_date = {}
    end
  end

  def homepage
    # Order by date (closest deadline first). Show only current_user's ideas; NULL dates at the end.
    if user_signed_in?
      @ideas = current_user.ideas.order(Arel.sql("COALESCE(date, '9999-12-31') ASC"))
    else
      @ideas = Idea.none
    end
  end
end
