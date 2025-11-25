class NotificationsController < ApplicationController
  def index
    logs = NotificationLog.all.order(created_at: :desc)
    render json: logs
  end

  def show
    log = NotificationLog.find_by(id: params[:id])

    if log
      render json: log
    else
      render json: { error: "Notificação não encontrada" }, status: :not_found
    end
  end

  def create
    p = notification_params

    log = NotificationLog.new(
      user_id: p[:user_id],
      notification_type: p[:notification_type],
      payload: p[:payload],
      status: "PENDENTE"
    )

    if log.save
      NotificationSenderJob.perform_later(log.id)
      render json: log, status: :accepted
    else
      render json: log.errors, status: :unprocessable_entity
    end
  end

  private

  def notification_params
    params.require(:notification).permit(
      :user_id,
      :notification_type,
      :recipient_email,
      payload: [ :message, :title, :link_url ]
    )
  end
end
