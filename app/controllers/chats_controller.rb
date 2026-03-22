class ChatsController < ApplicationController
  before_action :set_chat, only: [ :show, :destroy ]

  def index
    @chats = current_user.chats.order(created_at: :desc)
  end

  def new
    @chat = current_user.chats.build
    @selected_model = params[:model]
    @chat_models = available_chat_models
  end

  def create
    prompt = params.dig(:chat, :prompt)
    if prompt.present?
      @chat = current_user.chats.create!(model: params.dig(:chat, :model).presence)
      ChatResponseJob.perform_later(@chat.id, prompt)

      redirect_to @chat, notice: "Chat was successfully created."
    end
  end

  def show
    @message = @chat.messages.build
  end

  def destroy
    @chat.destroy!
    redirect_to chats_path, notice: "Chat was successfully destroyed.", status: :see_other
  end

  private

  def set_chat
    @chat = current_user.chats.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to chats_path, alert: "Chat not found."
  end
end
