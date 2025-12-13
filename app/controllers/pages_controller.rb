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
      @stats = {
        not_started: current_user.ideas.not_started.count,
        in_progress: current_user.ideas.in_progress.count,
        completed: current_user.ideas.completed.count
      }
    else
      @ideas = Idea.none
      @stats = { not_started: 0, in_progress: 0, completed: 0 }
    end
  end
end
