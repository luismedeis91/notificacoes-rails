class NotificationSenderJob < ApplicationJob
  queue_as :default

  def perform(notification_log_id)
    log = NotificationLog.find_by(id: notification_log_id)

    if log.nil?
      Rails.logger.error("NotificationSenderJob: log #{notification_log_id} não encontrado")
      return
    end

    # Recupera dados do payload, garantindo que NUNCA quebre
    message          = log.payload.is_a?(Hash) ? log.payload["message"] : nil
    recipient_email  = log.payload.is_a?(Hash) ? log.payload["recipient_email"] : nil

    begin
      puts "Iniciando envio..."
      puts "Mensagem: #{message.to_s[0..30]}"
      puts "Para: #{recipient_email}"

      sleep 2 # simulação

      log.update!(status: "ENVIADO")

    rescue StandardError => e
      Rails.logger.error("Erro ao enviar (id #{log.id}): #{e.message}")
      log.update!(status: "FALHA")
    end
  end
end
