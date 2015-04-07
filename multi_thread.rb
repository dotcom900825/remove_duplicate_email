require "benchmark"
require "faker"
require "./worker.rb"

worker_size = 10
email_array = []
output = []
duplicate_email = Faker::Internet.email

500.times do 
  random_email = Faker::Internet.email
  while random_email != duplicate_email
    email_array << random_email
    break    
  end
  email_array << duplicate_email
end

test_array = email_array.shuffle

chunked_array = Array.new(worker_size) {[]}
test_array.each do |email|
  hash = email.hash
  chunked_array[hash % worker_size] << email
end

worker_array = []

Benchmark.bm do |bm| 
  bm.report do 
    threads = chunked_array.each do |sub_array|
      Thread.new do
        worker = Worker.new(sub_array)
        worker_array << worker
        worker.remove_duplicates
      end
    end

    threads.each {|thr| thr.join}
    worker_array.map {|worker| output << worker.array}
    output.flatten!
  end
end