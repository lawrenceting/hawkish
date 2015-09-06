# Preview all emails at http://localhost:3000/rails/mailers/model_mailer
class ModelMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/model_mailer/new_update_notification
  def new_update_notification
    ModelMailer.new_update_notification
  end

end
