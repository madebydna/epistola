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

Start the Rails server before running the rake task to download messages from Gmail

    rake mail_bot:download_messages
    
By default this will download messages sent through the Google Group "ruby-mendicant-university" and save them to the database, preserving the threaded nature of the messages. At the moment the number of messages is capped at 60. 

Messages can now be browsed by group and by thread at `localhost:3000`

### Main Features

* MailBot API to download messages from Google Groups (see `lib/mail_bot`)
* Multiple groups
* Threaded messages
* Basic search over conversation subject and message body either in all groups or in a particular group
    
### TODO/Issues

* Fix remaining encoding issues
  * PGError: ERROR:  invalid byte sequence for encoding "UTF8"
  * Encoding::CompatibilityError incompatible character encodings: UTF-8 and ASCII-8BIT
* Add tests for MailBot functionality
* Lay foundation to support multiple mail-to-message mappers. Mail headers, etc. will differ depending on the mailing list back-end, while the message object is always the same
* Remove matches from quoted part of message from searches to avoid duplication (?)
* Design/Views
  * collapse quoted part of message
  * collapse entire message
  * color code different authors


    
