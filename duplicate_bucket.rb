$: << File.dirname(__FILE__)
require 'include'

source_bucket = ''
target_bucket = ''
prefix = ''

#Delete target_bucket
$s3.incrementally_list_bucket(target_bucket, "prefix" => prefix) {|i|
  i[:contents].each do |key|
    puts "Deleting: #{target_bucket}/#{key[:key]}"
    begin
      $s3.delete(target_bucket,key[:key])
    rescue
      sleep 5
      retry
    end
  end
}

$s3.incrementally_list_bucket(source_bucket, "prefix" => prefix) {|i|
  i[:contents].each do |key|
    puts "Copying: #{source_bucket}/#{key[:key]} -> #{target_bucket}/#{key[:key]}"
    begin
      $s3.copy(source_bucket, key[:key], target_bucket, key[:key])
    rescue
      sleep 5
      retry
    end
  end
}
