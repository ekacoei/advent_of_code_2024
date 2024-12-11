

inputtarray=File.read(ARGV[0]).split(/\s+/).map( &:to_i)

puts inputtarray.inspect

def iterate(input) #=> in array_of_int out array_of_int
  out=Array.new
  input.each do |int|
    puts int.class
    if int==0
      out.push(1)
      next
    end
    if int.to_s.length%2 == 0
      numstr=int.to_s
      puts numstr.inspect
      left_s= numstr [ 0..(numstr.length/2)-1 ]
      right_s= numstr [ (numstr.length/2).. ]
      puts "left=#{left_s}, right=#{right_s}"
      out.push(left_s.to_i)
      out.push(right_s.to_i)
      next
    end
    out.push( int * 2024 )
  end
  return out
end

puts "Initial arragngement"
puts inputtarray.join(" ")

res=inputtarray
25.times do |i|
  res=iterate(res)
  puts "After #{i} blinks"
  puts res.join(" ")
end

puts "Anzahl Steine #{res.length}"

# Korrekte Lösung: 194782
