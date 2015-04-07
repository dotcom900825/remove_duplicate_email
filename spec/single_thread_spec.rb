require_relative "../worker.rb"
require "faker"

describe "Single thread solution" do

  before do 
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

    @test_array = email_array.shuffle
  end

  it "should remove all duplicate emails" do
    worker = Worker.new(@test_array)
    worker.remove_duplicates
    expect(worker.array.uniq.size).to eq worker.array.size
  end

end