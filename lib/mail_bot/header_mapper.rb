require 'mail'

module MailBot
  
  class HeaderMapper
    
    # This is temporary:
    # we will need a "Mappable" module that adds the default mapping behavior
    # and classes such as GoogleGroupsMapper
    
    def map(mail)
      # we're going to need:
      #   Received: by 10.229.99.140 with SMTP id u12cs15387qcn; Sun, 11 Jul 2010 07:06:55 -0700 (PDT)  
      #   List-ID: <ruby-mendicant-university----general.googlegroups.com>
      #   Sender: ruby-mendicant-university----general@googlegroups.com
      #   From: Stuart Ellis <stuart@stuartellis.eu>
      #   Date: Sun, 11 Jul 2010 15:06:15 +0100
      #   Message-ID: <414BA815-BE88-4B53-A280-B906B3E059F8@stuartellis.eu>
      #   In-Reply-To: <4C3753E5.7060903@letterboxes.org>
      #   Subject: Re: Discussion thread for RMU Entrance Exam
      msg = {:message => {
        :group => mail.sender[/(.*)@googlegroups.com/,1].gsub(/-/, ' ').squeeze, 
        :guid => mail.header['Message-ID'].to_s[/<(.*)@[\w\.-]+>/, 1],
        :in_reply_to => mail.header['In-Reply-To'].to_s[/<(.*)@[\w\.-]+>/, 1],
        :user => mail.header['From'].to_s,
        :body => mail.body.decoded,
        :created_at => get_sent_date(mail),
        :subject => mail.subject
      }}
      json_msg = msg.to_json
    end
    
    def get_sent_date(mail)
      # the simple mail.date returns the date in the timezone of the sender, which leads  
      # to inconsistencies in the order the messages were received
      # Need to parse the date out of one of the "Received" headers. There might be a better way to do this ...
      f = Mail::ReceivedField.new(mail.received.first)
      f.date_time.to_s(:db)
    end
    
  end

end