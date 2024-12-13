class Koordinate
  def initialize(y,x)
    @y=y
    @x=x
  end
  def y
    return @y
  end
  def x
    return @x
  end
  def a
    return [@y, @x]
  end
  def hash
    return (@y+1)*1000+@x
  end
  def dup
    return Koordinate.new(@y,@x)
  end
  def eql?(b)
    if @y==b.y && @x==b.x
     return true
    end
    return false
  end
end

class Map
  def initialize()
    str=File.read(ARGV[0])
    @ymin=0
    @ymax=str.chomp.split("\n").length-1
    @xmin=0
    @xmax=str.chomp.split("\n")[0].length-1
    @data=Array.new
    str.chomp.split("\n").each_with_index do |line, yidx| 
      @data[yidx]=Array.new
      line.chomp.split("").each_with_index do |char, xidx |
        @data[yidx][xidx]=char
      end
    end
  end
  def getc(y,x)
    return @data[y][x]
  end
  def setc(y,x,c)
    @data[y][x]=c
  end
  def onMap?( k )
    ret = true
    ret = false if k.x < @xmin
    ret = false if k.y < @ymin
    ret = false if k.x > @xmax
    ret = false if k.y > @ymax
    return ret #wieso muss ich das returnen - reicht nicht das $(ret =) der vorhergehenden Zeile
  end
end


class Area
  def initialize(y,x)
    @y=y
    @x=x
    @perimeter=Array.new
    @area=Array.new
    @area.push( Koordinate.new(y,x) )
    @dijkstra=Array.new
    @dijkstra.push( Koordinate.new(y,x) )
    @letter=$m.getc(y,x)
    @done=false
  end
  def eql?(b)
    return true if (@y=b.y && @x=b.x)
    return false
  end
  def hash
    return @y*20000+@x
  end
  def x
    return @x
  end
  def y
    return @y
  end
  def iterate
    current=@dijkstra
    candidate=Array.new
    fence=Array.new
    area=Array.new # neu in der Iteration hinzu gewonnene Flächen

    current.each do |k|
      x=k.x
      y=k.y
      candidate.push( Koordinate.new( y+1, x))
      candidate.push( Koordinate.new( y, x+1))
      candidate.push( Koordinate.new( y-1, x))
      candidate.push( Koordinate.new( y, x-1))
    end
    candidate.each do | c |
      candidate_letter = $m.getc( c.y, c.x )
      puts "Trying koord=#{c.inspect} letter=#{candidate_letter}, onMap?=#{$m.onMap?(c)}"
      if $m.onMap?(c) && candidate_letter == @letter
        puts "Füge #{c.inspect} zum Area #{area.inspect} hinzu"
        area.push(c.dup)
        area<<c.dup
      end
      if ! $m.onMap?(c) || candidate_letter != @letter
        puts "Füge #{c.inspect} zum Zaun #{fence.inspect} hinzu"
        fence.push(c)
      end
    end

    fence.each do |f|
      @perimeter.push(f)
    end
    area.each do |a|
      @area.push(a)
    end

    puts "Debug: Neu hinzugewonnene Fächen #{area.inspect}"
    puts "Debug: Neu hinzugewonnene Zäune #{fence.inspect}"

    # Wichtig: Eine Zaunkoordinate kann von bis zu 4 Seiten hinzugefügt werden
    # Wichtig: Eine gehört-zur-Fläche-Koordinate muss uniq sein
    @area.uniq {|koord| koord.hash}

    @dijkstra=area.uniq {|koord| koord.hash}

    puts "Debug Dijkstra=#{@dijkstra.inspect}"


    # defekt. Vermutlich wegen globaler Variable $m=Map.new
#    area_before=Marshal.load(Marshal.dump(@area))
#    area_after=Marshal.load(Marshal.dump(@area)).uniq { |k| k.hash }

#    #defekt - aber warum?
#    area_before=Array.new
#    area_after=Array.new
#    @area.each do |k|
#      puts "Debug #{k.dup.class} #{k.dup.inspect}"
#      area_before.push( k.dup)
#      area_after.push( k.dup)
#    end
#    #ende defekt

    # wenn der dijkstra leer ist, bin ich fertig.
    # subtrahiere bekannte Fläche/area vom Diskstra
    @dijkstra = @dijkstra - @area
    
  end
end

$m=Map.new
puts $m.inspect
a=Area.new(0,0)
a.iterate
puts
a.iterate
