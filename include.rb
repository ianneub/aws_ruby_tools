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

$s3 = RightAws::S3Interface.new(awsAccessKey, awsSecretKey)