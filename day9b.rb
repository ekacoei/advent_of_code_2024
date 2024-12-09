#

# input manipulieren, dass die paare aufgehen. Ein Eintrag besteht immer aus Datei+Space

# disk file111 file222 file333

# 9b - mit dem Scan (\d) (\d) Arbeiten - wenn
#  - vom rechten Teil der Disk (index=high) der vordere Teil
#  - in einen linken TEil der Disk (index=low) passt, dann verschieben
# Aus
# (1, 3) - ein Block Datei, 3 Block frei
# (2, 0) - Zwei Block Datei, 0 Block frei
# wird
# (1,0)
# (2,3-2)

res=File.read( ARGV[0] ).scan( %r{(\d)(\d)} ).map { |an_array| an_array.map { |x| x.to_i} }
puts res.inspect

lptr=0
rptr=res.length-1
while rptr > 0
  blocksize=res[rptr][0]
  while lptr < rptr
    free=res[lptr][1]
    if free >= blocksize
      # verschobene Datei in den freien Bereich links einfügen,
      # anschließend aus Speicher hinten dem freien Speicher zuordnen
      res[lptr][1] -= blocksize
      res.insert( lptr+1, [blocksize, free-blocksize] )
      res[rptr][0]=0
      res[rptr][1]+=blocksize
      break
    end
    lptr += 1
  end
  rptr -= 1
end

puts res.inspect

exit

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
