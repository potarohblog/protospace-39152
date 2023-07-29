class PrototypesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :authorize_user, only: [:edit, :update, :destroy]

  def index
    @prototypes = Prototype.includes(:user).order('created_at DESC')
  end

  def new
    @prototype = Prototype.new
    @prototype.images.build
  end

  def create
    @prototype = Prototype.new(prototype_params)
    if @prototype.save
      redirect_to root_path, notice: '投稿完了'
    else
      flash.now[:alert] = '投稿失敗！'
      render :new
    end
  end

  def show
    @prototype = Prototype.find(params[:id])
    @comment = Comment.new
    @comments = @prototype.comments.includes(:user)
  end

  def edit
    @prototype = Prototype.find(params[:id])
  end

  def update
    @prototype = Prototype.find(params[:id])
    if @prototype.update(prototype_params)
      redirect_to prototype_path(@prototype.id), notice: 'アカウントを修正しました'
    else
      flash.now[:alert] ='アカウントを修正できませんでした'
      render :edit
    end
  end

  def destroy
    @prototype = Prototype.find(params[:id])
    if @prototype.destroy
      redirect_to root_path, notice: '削除しました'
    else
      flash.now[:alert] ='削除に失敗しました'
      render :edit
    end
  end

  private

  def prototype_params
    params.require(:prototype).permit(
      :title,
      :catch_copy,
      :concept,
      images_attributes: [:id, :image, :_destroy]
    ).merge(user_id: current_user.id)
  end

  def set_prototype
    @prototype = Prototype.find(params[:id])
  end

  def contributor_confirmation
    redirect_to root_path unless current_user == @prototype.user
  end
end

def authorize_user
  @prototype = Prototype.find(params[:id])
  unless @prototype.user == current_user
    redirect_to root_path, alert: '投稿者以外はアクセスできません'
  end
end