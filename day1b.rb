#/usr/bin/ruby

left = Array.new
right = Array.new
similarity_score=0

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

righthash=Hash.new(0)
right.each do |num|
  righthash[num.to_i] += 1
end

puts righthash.inspect

# Nur die aus der linken Liste werden überhaupt in die Zählung aufgenommen
left.each do |num|
  cnt=righthash[num.to_i]
  similarity_score += cnt * num.to_i
end

puts "Puzzlelösung=", similarity_score
