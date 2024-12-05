#day5a

#parse dependencies
# 5|4
# 5 kommt vor 4
# dependencies sind ein Array - 5 hat mehrere Nachfolger oder keine
# dependencies sind ein ARray - 4 hat mehrere Vorgänger oder keine

# sortieren gibt es mehrere
# 35,58,32,63,89,99,72,79,68
# Sortierungen genügen den Dependencies oder nicht
# Sortierungen haben eine Middle-Page-Number
# 35,58,32,63,89,99,72,79,68
#             ^^ middle page number

# Puzzlelösung:
# Sofern diese Sortierung genügt, addiere ihre Middle-Page-Number auf

# Datenstruktur: Seen
# page.

# Zeitbedarf 5a:
#  Aufgabenstellung Lesen, Lösungsstruktur Skizzieren 15min
#  Pause
#  Lösungsstruktur in Ruby-Klasse gießen, input parsen, input mit geparstem input Vergleichen: 45min
#  5a teil 2 - Class ordering parsen 15min
#  Pause. Aufmerksamkeitsspanne gerissen
#  Aufgabenstellung noch einmal lesen


class BeforeAfterRule
  def initialize(first_num_in_ruleset)
    @num=first_num_in_ruleset  
    @seen_self=false
    @done=false
    @valid=true
    @seen=Array.new
    @before=Hash.new(0)
  end

  def addpage( pagenumber )
    unless @done
      @seen.push(pagenumber)
      rule_exists=@before[pagenumber]
      if rule_exists 
        puts "Adding #{pagenumber} to #{@seen.join(',')} invalidates rule #{@num}|#{pagenumber}"
        valid=false
      end
      if pagenumber == @num
        @done=true
        
      end
    end
  end
  def addrule( before_this_num)
    @before[before_this_num] += 1
  end
  def prettyprint
    @before.keys.sort.each do |key|
      puts "#{@num}|#{key}"
    end
  end
end

puzzleinput = File.read('day5sample.input')

puts puzzleinput
rulestring,pageorderingstring=puzzleinput.split("\n\n")

puts "Rules=#{rulestring}"
puts "Pageordering=#{pageorderingstring}"

$ruleset=Hash.new
rulestring.split("\n").each do | beforePipeAfter | 
  before,after=beforePipeAfter.split('|')
  success = $ruleset[before]
  unless success
    $ruleset[before]=BeforeAfterRule.new(before)
  end
  $ruleset[before].addrule(after)
end

puts "Rules ordered\n#{rulestring.split("\n").sort.join("\n")}"

puts "Debug Ruleset"
$ruleset.keys.sort.each do |k|
  $ruleset[k].prettyprint
end

# TEIL 5a 2 - Seiten einlesen

pageorderingstring.split("\n").each do |orderingline|
  orderingline=orderingline.chomp
  rs=$ruleset.dup
  orderingline.split(',') do |a_page|
    rs.keys.sort.each do | rulekey |
      rs[rulekey].addpage( a_page)
    end
  end
end
