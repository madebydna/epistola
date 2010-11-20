# encoding: utf-8
require 'mail'

module MailBot
  
  class HeaderMapper
    
    # This is temporary:
    # we will need support for different mailing list backends, such as GoogleGroupsMapper
    
    def map(mail)
      force_utf_8_encoding(mail)
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
        :body => @mail_body,
        :created_at => get_sent_date(mail),
        :subject => mail.subject
      }}
      json_msg = msg.to_json
    end
    
    def force_utf_8_encoding(mail)
      if mail.multipart? 
        @mail_body = Mail::Encodings.q_value_encode(mail.parts.first.body, 'UTF-8').
                     to_s.force_encoding('UTF-8')
      else
        if mail.body.encoding == '7bit'
          @mail_body = mail.body.decoded
        else
          @mail_body = mail.body.raw_source.force_encoding('UTF-8').
                       encode('UTF-8')
        end
      end
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