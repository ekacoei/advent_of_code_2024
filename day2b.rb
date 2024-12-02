# AoC Day2b

# Teilaufgabe 2: Iteriere: Lösche einen Wert aus der Liste, schaue ob safe

# Teilaufgabe 1: Diff zwischen zwei Elementen einer Liste, die Diff-Liste ist ein Element kürzer als die Ausgangsliste
#   - in der Liste darf kein ABS[Element] kleiner als eins oder größer als 3 sein. Sortiere die Liste, schau dir erstes und letztes Element an.
#   - in der Liste müssen alle Zahlen kleiner als Null oder alle Zahlen größer als Null sein


class Array
  def neighbor_element_diff
    ret = Array.new
    (self.length-1).times do |idx|
      ret.push( self[idx+1]-self[idx] )
    end
    return ret 
  end
  def abs
    self.map { |num| num.abs }
  end
  def abs_mindestens_eins?
    return (self.abs.sort.first >= 1)
  end
  def abs_maximal_drei?
    return (self.abs.sort.last <= 3)
  end
  def alle_negativ?
    self.each { |num|
      if num > 0
        return false
      end
    }
    return true
  end
  def alle_positiv?
    self.each { |num|
      if num < 0
        return false
      end
    }
    return true
  end
  def safe?
    a=self.neighbor_element_diff.abs_mindestens_eins?
    b=self.neighbor_element_diff.abs_maximal_drei?
    c=self.neighbor_element_diff.alle_negativ?
    d=self.neighbor_element_diff.alle_positiv?
    return (a) && (b) && ( c || d)
  end
end

puts [1,2,4].neighbor_element_diff
puts [1,-1].abs
puts [-1].abs_mindestens_eins?
puts [4].abs_maximal_drei?

puts [4].alle_negativ?
puts [-4].alle_negativ?
puts [-1,-2].alle_negativ?
puts [-1,2].alle_negativ?


puts [1].alle_positiv?
puts [2,4].alle_positiv?
puts [2,-4].alle_positiv?

safe=0

ARGF.each_with_index do | line |
  report=line.chomp.split(/[^\d]/).map{ |n| n.to_i}

  a=report.neighbor_element_diff.abs_mindestens_eins?
  b=report.neighbor_element_diff.abs_maximal_drei?
  c=report.neighbor_element_diff.alle_negativ?
  d=report.neighbor_element_diff.alle_positiv?
  is_safe = (a) && (b) && ( c || d)

#  while !is_safe
  if !is_safe
    report.length.times do |i|
      cpy=report.dup
      cpy.delete_at(i)
#      puts "Debug Original #{report.join(' ')}"
#      puts "Debug Delete   #{cpy.join(' ')}"
      is_safe=cpy.safe?
      if is_safe
        puts "Manipuierter Report [#{cpy.join(' ')}] ist safe"
        break
      end
    end
  end
    
#  puts "Debug:"
#  puts "Original:", report.inspect
#  puts "Diff    :", report.neighbor_element_diff.inspect
#  puts "Diff-abs:", report.neighbor_element_diff.abs.inspect
#  puts "Abs     :", report.abs.inspect
#  puts "Min 1   :", report.neighbor_element_diff.abs_mindestens_eins?
#  puts "Max 3   :", report.neighbor_element_diff.abs_maximal_drei?
#  puts "a       :", a
#  puts "b       :", b
#  puts "c       :", c
#  puts "d       :", d
#  puts "is_safe :", is_safe

  if is_safe
    safe+=1
    puts report.inspect, " ist safe"
  end

#
#  puts report.inspect
#  puts report.neighbor_element_diff.inspect
#  puts report.neighbor_element_diff.abs.inspect
#  puts report.neighbor_element_diff.abs.sort.inspect
#  puts report.neighbor_element_diff.abs.sort.last.inspect
#  puts report.neighbor_element_diff.abs_maximal_drei?

  STDERR.puts "#{report.join(' ')} #{is_safe.to_s.capitalize}"

end

puts "Puzzlelösung=", safe

# Lösungsabgabe 1: 229 too low.
# Lösungsabgabe 2: 230. richtig. Aber geraten, keine Ahnung warum.

# Submission Tag2b: 300. Feedback. Too low
# Submission Tag2b: 301. Feedback: Korrekt.

