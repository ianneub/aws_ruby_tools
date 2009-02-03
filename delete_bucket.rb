$: << File.dirname(__FILE__)
require 'include'

#WARNING: This will delete all keys in a bucket!!

source_bucket = ''

$s3.incrementally_list_bucket(source_bucket) {|i|
  i[:contents].each do |key|
    begin
      puts "Deleting: #{source_bucket}/#{key[:key]}"
      $s3.delete(source_bucket, key[:key])
    rescue
      sleep 5
      retry
    end
  end
}

puts "Deleting bucket: #{source_bucket}"
$s3.delete_bucket source_bucket