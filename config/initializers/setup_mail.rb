# Email settings
ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = { 
  :address => "smtp.gmail.com", 
  :port => 587, 
  :domain => 'madebydna.com', 
  :user_name => 'info', 
  :password => 'yoyo1492', 
  :authentication => 'plain',
  :enable_starttls_auto => true }