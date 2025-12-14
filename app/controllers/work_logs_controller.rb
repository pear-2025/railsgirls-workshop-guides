class WorkLogsController < ApplicationController
  before_action :authenticate_user!
  def index
    @work_logs = current_user.work_logs.order(work_date: :desc)
    
    # 過去7日間の作業時間を日毎に集計
    seven_days_ago = Date.today - 6
    daily_stats = @work_logs.where('work_date >= ?', seven_days_ago)
                            .group(:work_date)
                            .sum(:work_hours)

    # グラフ用にデータを整形
    @weekly_stats = (0..6).map do |i|
      date = Date.today - i
      [date.strftime('%m/%d'), daily_stats[date] || 0]
    end.reverse.to_h
  end

  def new
    @work_log = current_user.work_logs.build
    @ideas = current_user.ideas.where(status: :completed)
  end

  def create
    @work_log = current_user.work_logs.build(work_log_params)

    if @work_log.save
      redirect_to work_logs_path, notice: '作業記録を登録しました。'
    else
      @ideas = current_user.ideas.where(status: :completed)
      render :new
    end
  end

  private

  def work_log_params
    params.require(:work_log).permit(:work_date, :work_hours, :task_name, :description, :idea_id)
  end

  def calculate_weekly_stats
    stats = {}
    7.days.ago.to_date.upto(Date.today) do |date|
      total_hours = current_user.work_logs.where(work_date: date).sum(:work_hours)
      stats[date.strftime('%m/%d')] = total_hours
    end
    stats
  end
end
