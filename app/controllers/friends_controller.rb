class FriendsController < ApplicationController
  before_action :authenticate_user!

  def friends_list
    @friends = current_user.friends.map(&:friend)
    @users = User.where.not(id: current_user.id)
    .where.not(id: current_user.friends.pluck(:friend_id))
    .page(params[:page])
    .per(2)  # Mostramos 2 usuarios por página
  end

  def index
    # Aquí mostramos todos los usuarios que no son el usuario actual
    @users = User.where.not(id: current_user.id)
  end

  def create
    @friend = User.find(params[:friend_id])

    # Verificar si ya son amigos para evitar duplicados
    unless current_user.friends.exists?(friend_id: @friend.id)
      # Crear la relación de amistad
      current_user.friends.create(friend: @friend)
      @friend.friends.create(friend: current_user) # Agregar recíprocamente

      # Responder con Turbo Stream para actualizar la vista sin recargar la página
      respond_to do |format|
        format.html { redirect_to friends_path, notice: "Amigo agregado con éxito." }
        format.turbo_stream do
          # Reemplazar el botón de "Agregar" con "Eliminar" para el amigo
          render turbo_stream: turbo_stream.replace("user_#{@friend.id}_friend_button", partial: "friends/remove_friend_button", locals: { user: @friend })
        end
      end
    else
      redirect_to friends_path, alert: "Ya eres amigo de este usuario."
    end
  end

  def destroy
    @friend = User.find(params[:friend_id])
    # Eliminar la relación de amistad
    current_user.friends.where(friend_id: @friend.id).destroy_all
    @friend.friends.where(friend_id: current_user.id).destroy_all

    respond_to do |format|
      format.html { redirect_to friends_path, notice: "Amigo eliminado con éxito." }
      format.turbo_stream do
        # Reemplazar el botón de "Eliminar" con "Agregar" si es eliminado
        render turbo_stream: turbo_stream.replace("user_#{@friend.id}_friend_button", partial: "friends/add_friend_button", locals: { user: @friend })
      end
    end
  end
end
