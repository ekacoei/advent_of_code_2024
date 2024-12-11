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

def visualize( array_of_fsblocks) 
  disk=Array.new
  array_of_fsblocks.each_with_index do |val, idx|
    file,space,fileindex=val
#      puts "Debug file=#{file}, space=#{space}, fileidx=#{fileindex}"
      file.times do
      disk.push( fileindex)
    end
  space.times do
    disk.push( '.')
  end
  puts disk.join()
  puts array_of_fsblocks.inspect
end

end

res=File.read( ARGV[0] ).scan( %r{(\d)(\d)} ).map { |an_array| an_array.map { |x| x.to_i} }
# Index muss mit transferiert werden
# (2, 0, 0) Dateilänge=2, Space=0, Index=0

for i in 0..res.length-1
  res[i].push(i)
end

puts res.inspect
visualize(res)

puts "nach indizierung", res.inspect

visualize(res)

lptr=0
rptr=res.length-1
while rptr > 0
  blocksize=res[rptr][0]
  lptr=0
  while lptr < rptr
    visualize(res)
    free=res[lptr][1]
    if free >= blocksize
      puts "Debug: Moving #{rptr} to #{lptr}"
      # verschobene Datei in den freien Bereich links einfügen,
      # anschließend aus Speicher hinten dem freien Speicher zuordnen
      res[lptr][1] -= blocksize
      free_space_left = res[lptr][1]
      res[lptr][1] = 0
      res.insert( lptr+1, [blocksize, free-blocksize, res[rptr][2]] )
      res[rptr][0]=0
      res[rptr][2]=0
      res[rptr][1]+=blocksize
      break
    end
    lptr += 1
  end
  rptr -= 1
end

puts res.inspect
visualize(res)





exit
  
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
