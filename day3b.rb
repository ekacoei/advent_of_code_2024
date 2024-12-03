# Advent of Code Day3a

# Workarounds: Zeilenumbrüche im Input entfernen.

# Aufgabenstellung:
#   RegEx mul(123,9)
#   Nach Zahlentupel parsen, einzelne Tupel multiplizieren
#   mehrere Tupel aufmultiplizieren

# Aufgabenstellung b:
#   trenne an do() und don't() auf, betrachte nur die do()
#   Nach Sichtung der Beispielaufgabe: Nimm an, dass sich ein do() vor dem String befunden hätte

sum=0
ARGF.each_with_index do | line |

  line= "do()" + line

  # splitte aktuelles do/dont plus beliebig viele Zeichen bis exklusive do/dont/Zeilenende
  do_and_not=line.scan( /(do\(\)|don't\(\))(.*?)(?=do\(\)|don't\(\)|$)/)
  puts do_and_not.inspect

  do_and_not.each { | drn|
    puts drn.inspect

  if drn[0] == "do()"
     puts "muss bearbeiteit werden #{drn}"

    #https://zzamboni.org/post/capturing-multiple-matches-in-ruby/
    res=drn[1].scan( /mul\(\d{1,3},\d{1,3}\)/ )
    puts res.inspect
    res.each { |str| 
      numberkommastrings=str.scan( /\d+,\d+/ ) #.split( /,/ )
      puts numberkommastrings.inspect
      numberkommastrings.each { |numstr|
        l,r = numstr.split(',')
        puts "l=#{l}, r=#{r}"
        l=l.to_i
        r=r.to_i
        STDERR.puts "(#{l},#{r})"
        zwischenergebnis = l*r
        sum+=zwischenergebnis
        puts "nuberkommastring #{numberkommastrings} #{l} #{r} #{zwischenergebnis} #{sum}"
      }
    }
  end
  }
end

puts sum

# 58488142
#not the right anwswer, to high
