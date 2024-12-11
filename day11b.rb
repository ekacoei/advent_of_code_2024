
# 11b
# Datenstruktur
#  [1337  75          ] x 1001
#   Zahl  rounds-to-go    count
# Beispiel
# 1337 0 0
#  [ 1337 75] x 1
#  [    0 75] x 2

class NumRounds
  def initialize( number, rounds_to_go)
    @number=number
    @rounds=rounds_to_go
  end
  def number
    return @number
  end
  def rounds
    return @rounds
  end
  def eql?(b)
    if (@number == b.number) && (@rounds == b.rounds)
      return true
    end
    return false
  end
  def hash
    return (@number+1)*100+@rounds
  end
  def sortval
    - (100000*(@rounds+1) + (100000-@number))
  end
end

def prettyhash(h)
  h.keys.sort_by { |o| o.sortval}.each do |k|
    puts "num=#{k.number}, rounds=#{k.rounds}, cnt=#{h[k]}"
  end
end


def iterateGamestate( state)
  out=Hash.new
  state.keys.sort_by{ |o| o.sortval}.each do |numRoundObject|
     cnt=state[numRoundObject]
     num=numRoundObject.number
     rou=numRoundObject.rounds
     if rou == 0
       puts "Fertig! #{numRoundObject.inspect}"
     end
     res_a=iterateNum(num)
     res_a.each do |n|
       new=NumRounds.new(n,rou-1)
       out[new] = 0 unless out.key?( new )
       out[new] += cnt
     end
  end
  return out
end

def iterateNum( input) #=> in int out array_of_int
  out=Array.new
  if input==0
    out.push(1)
  elsif input.to_s.length%2 == 0
      numstr=input.to_s
      left_s= numstr [ 0..(numstr.length/2)-1 ]
      right_s= numstr [ (numstr.length/2).. ]
      out.push(left_s.to_i)
      out.push(right_s.to_i)
  elsif
    out.push( input * 2024 )
  end
  return out
end



# initiales Setup der Input-Datei
inputtarray=File.read(ARGV[0]).split(/\s+/).map( &:to_i)

puts inputtarray.inspect
gamestate=Hash.new(0)

inputtarray.each do |num|
  puts "processing #{num}"
  key=NumRounds.new(num, 75)
  gamestate[ key ] = 0 unless gamestate.key?( key )
  gamestate[ key ] += 1
end

prettyhash( gamestate)

# initiales Setup fertig

puts gamestate.inspect

gs_new=Marshal.load(Marshal.dump(gamestate))

75.times do |i|
  puts "After #{i+1} blink:"
  gs_new=iterateGamestate( gs_new)
  prettyhash( gs_new)
end

#puzzlelösung
sum=0
gs_new.each do |k,v|
  sum+=v
end
puts "Puzzlelösung #{sum}"

# Korrekte Lösung: 194782 teil-a
# 11b submission 65601038650482 - to low
# 11b submission 233007586663131 - korrekt
