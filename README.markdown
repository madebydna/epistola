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
    
Install the seed data

    rake db:seed
    
If anything went wrong, just remigrate. This will destroy all data in the db and migrate again.

    rake db:remigrate
    
### Features

* Multiple groups
* Conversations and messages
* Basic search over conversation subject and message body either in all groups or in a particular group
    
### TODO

* Seed data: add some variation in hours for messages (not just days)
* When displaying list of conversations in a particular group, then sort by last message
* Add further "caching" fields, such as last_message_id and last_message_user in conversation (an in group, maybe) 
* Problem with adding other caching fields is that the gems used to create seed data skip callbacks

    
