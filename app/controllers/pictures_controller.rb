class PicturesController < ApplicationController

  before_action :set_params, only: [:edit, :update, :show, :destroy]

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
    if current_user.nil?
      redirect_to new_session_path
    else
      @favorite = current_user.favorites.find_by(picture_id: @picture.id)
    end
  end

  def edit
  end

  def updated
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
    params.require(:picture).permit(:content, :image)
  end

  def set_params
    @picture = Picture.find(params[:id])
  end

end
