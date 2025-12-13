class PagesController < ApplicationController
  def about
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
