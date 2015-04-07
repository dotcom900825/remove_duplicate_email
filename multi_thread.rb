require "benchmark"
require "faker"
require "./worker.rb"

email_array = []
output = []
duplicate_email = Faker::Internet.email

500000.times do 
  random_email = Faker::Internet.email
  while random_email != duplicate_email
    email_array << random_email
    break    
  end
  email_array << duplicate_email
end

test_array = email_array.shuffle

chunked_array = test_array.each_slice(50000).to_a
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
  end
end