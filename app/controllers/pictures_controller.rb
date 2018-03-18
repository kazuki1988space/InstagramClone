class PicturesController < ApplicationController

  before_action :set_params, only: [:edit, :update, :show, :destroy]
  before_action :logged_in?, only:[:new, :edit, :show]

  def index
    @pictures = Picture.all
  end

  def new
    if params[:back]
      @picture = Picture.new(picture_params)
    else
      @picture = Picture.new
    end
  end

  def confirm
    @picture = Picture.new(picture_params)
    if !@picture.content.present?
      flash[:danger] = "記事を入力して下さい"
      if !@picture.image_cache.present?
        flash[:danger] = "記事と画像を入力して下さい"
      end
      redirect_to new_picture_path
    elsif !@picture.image_cache.present?
      flash[:danger] = "画像を入力して下さい"
      redirect_to new_picture_path
    end
  end

  def create
    @picture = Picture.new(picture_params)
    @picture.user_id = current_user.id
    @picture.image.retrieve_from_cache! params[:cache][:image]

    if @picture.save
      ContactMailer.contact_mail(@picture).deliver
      redirect_to pictures_path, notice: "記事を投稿しました"
    else
      render "new"
    end
  end

  def show
    @favorite = current_user.favorites.find_by(picture_id: @picture.id)
  end

  def edit
  end

  def update
    if @picture.update(picture_params)
      redirect_to pictures_path, notice: "記事を編集しました"
    else
      render "edit"
    end
  end

  def destroy
    @picture.destroy
    redirect_to pictures_path, notice: "記事を削除しました"
  end

  private
  def picture_params
    params.require(:picture).permit(:content, :image, :image_cache, :cache)
  end

  def set_params
    @picture = Picture.find(params[:id])
  end

  def logged_in?
    if current_user.nil?
      flash[:danger] = "ログインして下さい"
      redirect_to new_session_path
    end
  end

end
