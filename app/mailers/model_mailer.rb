class ModelMailer < ApplicationMailer

	# Subject can be set in your I18n file at config/locales/en.yml
	# with the following lookup:
	#
	#   en.model_mailer.new_update_notification.subject
	#
	
	default from: "update@hawkishapp.com"
	
	def new_update_notification(tracker, updates)
		@greeting = "Hi"
		@tracker = tracker
		@updates = updates

		mail 	to: "szesamltss@gmail.com", 
				subject: "#{@tracker} has recently been updated."
	end
end
