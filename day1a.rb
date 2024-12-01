#/usr/bin/ruby

left = Array.new
right = Array.new
total_distance = 0

# https://stackoverflow.com/questions/273262/best-practices-with-stdin-in-ruby
#ARGF.each_with_index do | line, idx|
#  printf ARGF.filename, line
#end

ARGF.each_with_index do | line |
#  printf line
  res=line.chomp.match( /(?<l>\d+)\s+(?<r>\d+)/ )
#  puts "match=", res, "\n"
  left.push( res[:l].to_i )
  right.push( res[:r].to_i )
  puts "left=", res[:l], "\n"
  puts "right=", res[:r], "\n"
end

puts "Linke liste", "\n", left
puts "rechte liste", "\n", right

puts right.inspect


left=left.sort
right=right.sort

left.length.times do |idx|
  d=(left[idx]-right[idx]).abs
  puts "d=", d
  total_distance += d
end

puts "Puzzlelösung Tag1a: ", total_distance
