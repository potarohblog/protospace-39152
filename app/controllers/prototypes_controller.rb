class PrototypesController < ApplicationController
  # ログインしていない時はnew、edit、update、destroyのページに遷移できないようにする
  before_action :authenticate_user!, only: [:new, :edit, :update, :destroy]

  def index
    @prototypes = Prototype.includes(:user).order('created_at DESC')
  end

  def new
    @prototype = Prototype.new
  end

  def create
    @prototype = Prototype.new(prototype_params)
    if @prototype.save
      redirect_to root_path
    else
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
    #違うユーザーが編集ページにアクセスできないようにする
    if @prototype.user != current_user
      redirect_to root_path
    end
  end

  def update
    @prototype = Prototype.find(params[:id])
    if @prototype.update(prototype_params)
      redirect_to @prototype
    else
      render :edit
    end
  end

  def destroy
    @prototype = Prototype.find(params[:id])
    #違うユーザーが投稿を削除できないようにする
    if @prototype.user != current_user
      redirect_to root_path
  end
end

  private

  def prototype_params
    params.require(:prototype).permit(
      :title,
      :catch_copy,
      :concept,
      :image
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
    redirect_to root_path
  end
end