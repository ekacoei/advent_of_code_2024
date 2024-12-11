# AOC Day8a

# Algorithmischer Trick:
# Die antinodes finden sich auf:
#  - Antennenvector der beiden Antennen
#  - Antenne 1 + Vector
#  - Antenne 1 - Vector
#  - Antenne 2 + Vector
#  - Antenne 2 - Vector
#  - Antenne 1 ist kein Antinode
#  - Antenne 2 ist kein Antinode

# Ergebnis muss keine Karte sein, es reicht ein Array von Koordinaten
# Aus diesem Array können Koordinaten gelöscht weren, die
#  - <0y
#  - <0x
#  - >ymax
#  - xmax sind
# Doubletten sind zu entfernen
# Die Länge des Arrays ist die Puzzlelösung

# Parsen des Inputs
# Hashmap
#  map['a'] = [ [1,0], [0,0] ]

# Programmablauf
#
# Nach dem Parsen für jeden Buchstaben
#   danach für jedes koordinatenpaar (wie in Bubblesort mit zwei Indizees)
#     das Array aus koordinaten durchgehen und die Antinodes berechnen
# abschließend Antinodes filtilren

class Vec 
  def initialize( y, x )
    @y=y
    @x=x
  end
  def plus( vec_b)
    x = @x + vec_b.x
    y = @y + vec_b.y
    return Vec.new( y, x)
  end
  def x
    return @x
  end
  def y
    return @y
  end
  def diff( vec_b)
    dx= @x - vec_b.x
    dy= @y - vec_b.y
    return Vec.new( dy, dx)
  end
  def genSignal( vec_b) # => Array of Coordinate-Array
    diff = self.diff( vec_b)
    a = self.plus( diff)
    b = self.minus( diff)
    c = vec_b.plus( diff)
    d = vec_b.minus( diff)
    res = Array.new
    res.push(a.asArray).push(b.asArray).push(c.asArray).push(d.asArray)
    puts "Debug: before #{res.inspect}"
    res.delete( self.asArray)
    res.delete( vec_b.asArray )
#    plan_b = res - self.asArray - vec_b
#    puts "Debug: after #{plan_b.inspect}"
    puts "Debug: after #{res.inspect}"
    return res
  end
  def plus( vec_b )
    x = @x + vec_b.x
    y = @y + vec_b.y
    return Vec.new( y, x)
  end
  def minus( vec_b )
    self.plus( Vec.new( -vec_b.y, -vec_b.x))
  end
  def asArray # => [y, x]
    r = Array.new
    r.push( @y)
    r.push( @x)
  end
end

class Map
  def initialize( puzzleinputstring)
    @miny=0
    @minx=0
    lines = puzzleinputstring.split("\n")
    @maxy=lines.length-1
    @maxx=lines[0].length-1
    @letters = Hash.new()
    ('a'..'z').to_a.each do | key  |
       @letters[key]=[]
    end
    ('A'..'Z').to_a.each do | key  |
       @letters[key]=[]
    end
    ('0'..'9').to_a.each do | key  |
       @letters[key]=[]
    end
    for yidx in 0..@maxy-1
      l=lines[yidx].chomp
      for xidx in 0..@maxx-1
        puts "Dbg: y=#{yidx},x=#{xidx}, l=#{l[xidx]}"
        if l[xidx] =~ /[a-zA-Z0-9]/
          puts "Dbg: RegEx match"
          @letters[ l[xidx] ].push( [yidx, xidx] )
          puts @letters.inspect
        end
      end
    end
  end
  def letters
    return @letters
  end
end

a1=Vec.new( 4, 5)
a2=Vec.new( 6, 6)

puts a1.inspect
puts a2.inspect

puts a1.genSignal(a2).inspect

pi = File.read( ARGV[0] )
puts pi
m=Map.new( pi)
puts m.letters.inspect
