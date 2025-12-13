class IdeasController < ApplicationController
  before_action :set_idea, only: %i[ show edit update destroy toggle_submission ]
  before_action :authenticate_user!, except: %i[ show ]

  # GET /ideas or /ideas.json
  def index
    @ideas = user_signed_in? ? current_user.ideas : Idea.none
  end

  # GET /ideas/1 or /ideas/1.json
  def show
    @comments = @idea.comments
  end

  # GET /ideas/new
  def new
    @idea = Idea.new
  end

  # GET /ideas/1/edit
  def edit
  end

  # POST /ideas or /ideas.json
  def create
    @idea = current_user.ideas.build(idea_params)

    respond_to do |format|
      if @idea.save
        format.html { redirect_to idea_url(@idea), notice: "タスクを作成しました。" }
        format.json { render :show, status: :created, location: @idea }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @idea.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ideas/1 or /ideas/1.json
  def update
    respond_to do |format|
      if @idea.update(idea_params)
        format.html { redirect_to idea_url(@idea), notice: "タスクを更新しました。" }
        format.json { render :show, status: :ok, location: @idea }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @idea.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ideas/1 or /ideas/1.json
  def destroy
    @idea.destroy!

    respond_to do |format|
      format.html { redirect_to ideas_url, notice: "タスクを削除しました。" }
      format.json { head :no_content }
    end
  end

  # PATCH /ideas/1/toggle_submission
  def toggle_submission
    authenticate_user!
    unless @idea.user_id == current_user.id
      render json: { error: "Unauthorized" }, status: :unauthorized
      return
    end
    @idea.update(submission: @idea.submission == 0 ? 1 : 0)
    respond_to do |format|
      format.html { redirect_to @idea, notice: "提出状態を更新しました。" }
      format.json { render json: { submission: @idea.submission } }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_idea
      @idea = Idea.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def idea_params
      params.require(:idea).permit(:name, :description, :picture, :date, :subject, :submission_method, :submission)    end
  end