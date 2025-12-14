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
      @submitted_count = current_user.ideas.where(submission: 1).count
      @not_submitted_count = current_user.ideas.where(submission: 0).count
    else
      @ideas = Idea.none
      @submitted_count = 0
      @not_submitted_count = 0
    end
  end

  def homepage
    if user_signed_in?
      @ideas = current_user.ideas.order(updated_at: :desc)

      if params[:tag].present?
        # タグ検索ロジック
        # tagsカラムに検索語が単独のタグとして含まれているものを検索します
        # (例: "ruby" で検索した場合に "ruby on rails" がヒットしないように)
        @ideas = @ideas.where("',' || tags || ',' LIKE ?", "%,#{params[:tag]},%")
      end

      @submitted_count = @ideas.where(submission: 1).count
      @not_submitted_count = @ideas.where(submission: 0).count
    else
      @ideas = Idea.none
    end
  end
end
