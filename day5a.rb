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
#  Bugfix: Erst, nachdem das Ruleset zu einer Seite diese Seite gesehen kann, können Regeln verletzt werden 35min
#  30min Ruby-Unwissen, hash.key


class BeforeAfterRule
  def initialize(first_num_in_ruleset)
    @num=first_num_in_ruleset
    @seen_self=false
    @done=false
    @valid=true
    @seen=Array.new
#    @before=Hash.new(0)
    @after_this_num=Hash.new(0) # Sollzustand - müssen danach folgen
  end
  def debug( msg)
     STDERR.puts msg
  end
  def addpage( pagenumber )
    unless @done
      @seen.push(pagenumber)
      rule_exists=@after_this_num.key?(pagenumber) # 5|4  pagenumber
      debug "thisClass=#{@num},Pagenumber=#{pagenumber},rule=#{rule_exists}"
      if rule_exists and (! @seen_self) and (@num == pagenumber)
        debug @after_this_num.inspect
        puts "Adding #{pagenumber} to #{@seen.join(',')} invalidates rule #{@num}|#{pagenumber}"
        @valid=false
#        @done=true - nicht abbrechen
      end
    end
    if pagenumber == @num
      @seen_self=true
      @done=true
    end
  end
  def addrule( after)
#    @before[before_this_num] += 1
    @after_this_num[after] += 1
  end
  def prettyprint
    @after_this_num.keys.sort.each do |key|
      puts "#{@num}|#{key}"
    end
  end
  def valid?()
    return @valid
  end
end

puzzleinput = File.read('day5sample.simplified.input')

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
  page_list=orderingline.split(',')
  page_list.each do |a_page|
    page_list.each do |rule_anchor|
      rs[rule_anchor].addpage (a_page)
    end
  end
  ruleset_is_valid_for_single_line = rs.all? do |ruleset |
    puts "Debug: #{rs.class}"
    puts "Debug: #{ruleset.class}"
    ruleset.valid?()
  end
  puts "#{orderingline} is valid=#{ruleset_is_valid_for_single_line}"
end

