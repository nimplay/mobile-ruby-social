class PagesController < ApplicationController
  def home
    if user_signed_in?
      @users = User.where.not(id: current_user.id)
                   .where.not(id: current_user.friends.pluck(:friend_id))
                   .page(params[:page])
                   .per(2) # Mostramos 2 usuarios por página

      friend_ids = current_user.friends.pluck(:friend_id)
      @posts = Post.where(user_id: [current_user.id] + friend_ids)
                   .order(created_at: :desc)
                   .page(params[:page])
                   .per(5) # Mostramos 5 posts por página
    else
      @users = User.all.page(params[:page]).per(2)
    end
  end
end
