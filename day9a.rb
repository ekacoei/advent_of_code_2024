#

# input manipulieren, dass die paare aufgehen. Ein Eintrag besteht immer aus Datei+Space

# disk file111 file222 file333

res=File.read( ARGV[0] ).scan( %r{(\d)(\d)} )
puts res.inspect
disk=Array.new
res.each_with_index do |val, idx|
  file,space=val
  file=file.to_i
  space=space.to_i
  file.times do
    disk.push( idx)
  end
  space.times do
    disk.push( -1)
  end
end

puts disk.inspect

leftidx=0
rightidx=disk.length-1
while leftidx < rightidx
  if disk[leftidx] != -1  
    leftidx += 1 
    next
  end
  if disk[rightidx] == -1
    rightidx -=1
    puts "Das hätte nicht passieren sollen"
    next
  end
  puts "Swapping #{leftidx} #{rightidx}"
  disk[leftidx]=disk[rightidx]
  disk[rightidx]=-1
  leftidx+=1
  rightidx-=1
end
  
puts disk.inspect

chsumdisk=disk.filter{ |val| val != -1 }
puts chsumdisk.inspect

chsum=0
chsumdisk.each_with_index do |val, idx|
  puts "Val=#{val}, idx=#{idx}"
  chsum += val*idx
end
puts "Puzzlelösung #{chsum}"

#Lösungsvorschlag 1: 6337910441366 - too low
#                    6340197768906 - korrekt
