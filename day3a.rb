# Advent of Code Day3a

# Aufgabenstellung:
#   RegEx mul(123,9)
#   Nach Zahlentupel parsen, einzelne Tupel multiplizieren
#   mehrere Tupel aufmultiplizieren

sum=0
ARGF.each_with_index do | line |
  #https://zzamboni.org/post/capturing-multiple-matches-in-ruby/
  res=line.scan( /mul\(\d{1,3},\d{1,3}\)/ )
  puts res.inspect
  res.each { |str| 
    numberkommastrings=str.scan( /\d+,\d+/ ) #.split( /,/ )
    puts numberkommastrings.inspect
    numberkommastrings.each { |numstr|
      l,r = numstr.split(',')
      puts "l=#{l}, r=#{r}"
      l=l.to_i
      r=r.to_i
      zwischenergebnis = l*r
      sum+=zwischenergebnis
      puts "nuberkommastring #{numberkommastrings} #{l} #{r} #{zwischenergebnis} #{sum}"
#      puts "nuberkommastring #{numberkommastrings} #{l} #{r} #{sum}"
    }
  }
end

puts sum
