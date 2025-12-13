class ProfilesController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
    @submitted = @user.ideas.where(submission: 1).count
    @not_submitted = @user.ideas.where(submission: 0).count
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(profile_params)
      redirect_to profile_path, notice: 'プロフィールを更新しました。'
    else
      render :edit
    end
  end

  private

  def profile_params
    params.require(:user).permit(:username, :avatar)
  end
end
