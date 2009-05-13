begin
  $: << File.dirname(__FILE__)
  require 'include'
  require 'rubygems'
  require 'net/http'
  require 'net/smtp'
  require 'digest/sha1'
  require 'right_aws'
  
  url_string = 'http://www.google.com/' # URL to check
  sdb_domain = ''                       # SimpleDB domain
  emailTo = ["Me", "me@mydomain.com"]   # Send notifications to here

  url = URI.parse(url_string)
  raw = Net::HTTP.get(url)
  hash = Digest::SHA1.hexdigest(raw)

  result = $sdb.select("select * from #{sdb_domain} limit 1")[:items][0]
  data = result["key"]["hash"][0]
  
  # puts $sdb.select("select * from #{sdb_domain}").inspect

  # $sdb.put_attributes(sdb_domain,"key",{:hash => hash}) if result.nil?
  # $sdb.delete_attributes sdb_domain,"key"

  if hash != data
    subject = 'Job posting has changed'
    message = "<p>The job page has changed on #{url_string}</p>\n#{raw}"
    send_email(emailTo[1], emailTo[0], subject, message)
    $sdb.delete_attributes(sdb_domain,"key",{"hash" => data})
    $sdb.put_attributes(sdb_domain,"key",{"hash" => hash})
    # puts "#{hash} vs #{data}"
  end
rescue => e
  puts "An error occured: #{e.inspect}"
end