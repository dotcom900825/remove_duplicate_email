class Worker

  attr_accessor :array

  def initialize(array)
    @array = array
  end

  def remove_duplicates
    counter_index = 0
    hash = Hash.new(false)

    @array.each do |email|
      if !hash[email]
        hash[email] = true
        @array[counter_index] = email
        counter_index += 1
      end
    end

    @array =  @array[0...counter_index]
  end
end