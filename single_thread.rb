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
worker = Worker.new(test_array)

Benchmark.bm do |bm| 
  bm.report do 
    worker.remove_duplicates
    output = worker.array
  end
end
    