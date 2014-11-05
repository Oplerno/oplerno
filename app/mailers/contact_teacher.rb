class ContactTeacher < ActionMailer::Base
	default from: 'webmaster@oplerno.com',
		bcc: 'admissions@oplerno.com'

	layout 'email'

	def student_mail(message)
		recipient = message[:email]
		@message = message
		course = message[:course]
		if course.nil?
			subject = "General Student Inquiry"
		else
			subject = "Student Inquiry on #{course[:name]}"
		end

		@sent_on = Time.now
		@headers = {}
		mail(subject: subject, to: recipient)
	end
end
