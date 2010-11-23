# Epistola

## Google Group Replacement for RMU University Web 

Proof of concept to discover features and requirements for a possible in-house mailing list solution for RMU. The first stage is to build out the archiving and searching features. 

### Installation

    git clone git://github.com/madebydna/epistola.git
    
Install all required gems:

    bundle install
    
Create database and run the migrations 
    
    rake db:create
    rake db:migrate
    
Rename `mail.yml.example` to `mail.yml` and change the configuration. 

Run the rake task to download messages from Gmail

    rake mail_bot:download_messages
    
By default this will download messages sent through the Google Group "ruby-mendicant-university" and save them to the database, preserving the threaded nature of the messages.

Run the server to browse messages: `rails s`

### Main Features

* MailBot API to download messages from Google Groups (see `lib/mail_bot`)
* Multiple groups
* Threaded messages
* Basic search over conversation subject and message body either in all groups or in a particular group
    
### TODO/Issues

* Add tests for MailBot functionality
* Lay foundation to support multiple mail-to-message mappers. Mail headers, etc. will differ depending on the mailing list back-end, while the message object is always the same
* Design/Views
  * collapse quoted part of message
  * collapse entire message
  * color code different authors


    
