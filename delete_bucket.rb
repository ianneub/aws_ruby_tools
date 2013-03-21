$: << File.dirname(__FILE__)
require 'include'

delete_bucket = ''
prefix = ''

# Thread management
delete_threads = []
delete_queue = Queue.new
mutex_total = Mutex.new
thread_count = 10

# Tracking variables
total_delete_listed = 0
total_deleted = 0

# Gather keys to be deleted
$s3.incrementally_list_bucket(delete_bucket, "prefix" => prefix) {|i|
  i[:contents].each do |key|
    delete_queue.enq(key[:key])
    total_delete_listed += 1
  end
}
thread_count.times {delete_queue.enq(:END_OF_BUCKET)}

# Deletion threads
thread_count.times do |count|
  delete_threads << Thread.new(count) do |number|
    Thread.current[:number] = number
    begin
      key = delete_queue.deq
      unless key == :END_OF_BUCKET
        $s3.delete(delete_bucket, key)
        # puts "Deleted: #{key}"
        mutex_total.synchronize {total_deleted += 1}
        puts "Deleted #{total_deleted} out of #{total_delete_listed}" if (rand(100) == 1)
      end
    end until (key == :END_OF_BUCKET)
  end  
end

delete_threads.each do |t| 
  begin
    t.join
  rescue RuntimeError => e
    puts "Failure on thread #{t[:number]}: #{e.message}"
  end
end

puts "Deleted #{total_deleted} out of #{total_delete_listed}"
