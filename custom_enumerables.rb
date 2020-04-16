module Enumerable
  def my_each
    return enum_for unless block_given?
    array = is_a?(Range) ? to_a : self

    for item in array
      yield(item)
    end
    array
  end

  def my_each_with_index
    return enum_for unless block_given?
    array = is_a?(Range) ? to_a : self

    for item in array
      yield(item, array.index(item))
    end
    array
  end

  def my_select
    return enum_for unless block_given?

    selected = []
    my_each{ |item| selected << item if yield(item) === true}
    selected
  end

  def my_all?
    my_each{ |item| return false if yield(item) === false}
    true
  end

  def my_any?
    my_each{ |item| return true if yield(item) === true}
    false
  end

  def my_none?(&block)
    !self.my_any?(&block)
  end

  def my_count(number = nil)
    array = is_a?(Range) ? to_a : self

    return array.length unless block_given? || number

    true_elements = []
    if number
      array.my_each { |item| true_elements << item if item == number}
    else
      array.my_each{ |item| true_elements << item if yield(item) === true}
    end
    true_elements.length
  end

  def my_map(proc = nil)
    return enum_for unless block_given?

    map = []
    if proc
      my_each { |item| map << proc.call(item)}
    else
      my_each{ |item| map << yield(item)}
    end
  end

  def my_inject(*args)
    reducer = args[0] if args[0].is_a?(Integer)

    if args[0].is_a?(Symbol)
      my_each{ |item| reducer = reducer ? reducer.send(args[0], item) : item}
      reducer
    else
      sum = 0
      each do |item|
        sum = yield(sum, item)
      end
      sum
    end
  end

  def multilply_els
    self.my_inject(:*)
  end
end


puts "My each demo"
[1, 2, 3, 4].my_each{ |e| puts e}
puts "\n"
(1...5).my_each{ |e| puts e*3}

puts "\n My each_with_index demo"
[1, 2, 3, 4].my_each_with_index do |e,i |
  puts "item: #{e}"
  puts "index: #{i}"
end
puts "\n"
(1..5).my_each_with_index do |e,i |
  puts "item: #{e}"
  puts "index: #{i}"
end

puts "\n My select demo"
p [1, 2, 3, 4, 6].my_select{ |e| e.even?}

puts "\n My all? demo"
puts [1, 2, 3, 4].my_all?{ |e| e.even?}
puts [1, 2, 3, 4].my_all?{ |e| e < 6}

puts "\n My any? demo"
puts [1, 2, 3, 4].my_any?{ |e| e.even?}
puts [1, 2, 3, 4].my_any?{ |e| e > 6}

puts "\n My none? demo"
puts [1, 2, 3, 4].my_none?{ |e| e.even?}
puts [1, 2, 3, 4].my_none?{ |e| e > 6}

puts "\n My count demo"
puts [1, 2, 3, 4].my_count
puts (1..5).my_count
puts [1, 1, 1, 1, 2, 2, 2].my_count(1)
puts [1, 2, 3, 4].my_count{ |e| e.even?}

puts "\n My map demo"
p [1, 2, 3, 4].map{ |e| e.even?}
p [1, 2, 3, 4].map{ |e| e*2}

puts "\n My map with a proc demo"
some_proc = proc{ |e| e**2 }
p [1, 2, 3, 4].map(&some_proc)
puts "\n"

puts "\n My inject demo"
puts [1, 2, 3, 4].my_inject{ |sum, n| n + 1}
puts [1, 2, 3, 4].my_inject{ |product, n| n * 3}
puts [1, 2, 3, 4].inject(:*)
puts [1, 2, 3, 4].my_inject(:*)

puts "\n My Multiply Elements demo"
puts [1, 2, 3, 4, 5, 6].multilply_els
