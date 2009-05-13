require 'rubygems'
require 'right_aws'

class RightAws::S3Interface
  
  def list_bucket_items(bucket, prefix = '')
    keys = Array.new
    $s3.incrementally_list_bucket(bucket, "prefix" => prefix) {|i|
      i[:contents].each do |key|
        keys << key
      end
    }
    return keys
  end
end

# AWS access info
awsAccessKey = ''
awsSecretKey = ''

#Email server info, only needed if sending emails
emailServerAddress = '' # 'mail.mydomain.com'
emailServerPort = 25
emailServerFromHelo = 'localhost.localdomain'
emailUserName = 'me@mydomain.com'
emailPassword = 'password'
emailAuthType = :login #:login, :plain, or :cram_md5
EmailFrom = ["My Ruby Script", "ruby@mydomain.com"]

defaultLogger = Logger.new("/dev/null")

  # hack to eliminate the SSL certificate verification notification
  class Net::HTTP
    alias_method :old_initialize, :initialize
    def initialize(*args)
      old_initialize(*args)
      @ssl_context = OpenSSL::SSL::SSLContext.new
      @ssl_context.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end
  end

  def send_email(to, to_alias, subject, message, options={})
  	msg = <<END_OF_MESSAGE
From: #{EmailFrom[0]} <#{EmailFrom[1]}>
To: #{to_alias} <#{to}>
MIME-Version: 1.0
Content-type: text/html
Subject: #{subject}

#{message}
END_OF_MESSAGE
	
  	Net::SMTP.start(emailServerAddress,emailServerPort,emailServerFromHelo,emailUserName,emailPassword,emailAuthType) do |smtp|
  		smtp.send_message msg, from, to
  	end
  end

$s3 = RightAws::S3Interface.new(awsAccessKey, awsSecretKey, :logger => defaultLogger)
$sdb = RightAws::SdbInterface.new(awsAccessKey, awsSecretKey, :logger => defaultLogger)