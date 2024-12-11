

inputstring=File.read( ARGV[0] )
zeilen=inputstring.chomp.split("\n").length
spalten=inputstring.split("\n")[0].length

puts "Spalten=#{spalten}, Zeilen=#{zeilen}"

class Map
  def initialize(ymax,xmax)
    @ymax=ymax
    @xmax=xmax
    @map = Array.new( ymax ) { Array.new( xmax, "o") }
    @pos=Array.new
    @direction=[-1,0] #up
    @left_coordinate_system=false
  end
  def prettyprint
    for y in 0..(@map.length-1)
      for x in 0..(@map[y].length-1)
        print @map[y][x]
      end
      print "\n"
    end
    puts "Pos=#{@pos} Dir=#{@direction}"
  end
  def parseInputString( str)
    str.split("\n").each_with_index do |line,y|
      line=line.chomp
      line.split('').each_with_index do | char, x |
#        puts "y=#{y}, x=#{x}, char=#{char}"
        @map[y][x]=char
        if char == '^'
          @pos=[y,x]
        end
      end
    end
  end
  def directionChooser( current) # => next
    return [0,1] if current==[-1,0]
    return [1,0] if current==[0,1]
    return [0,-1] if current==[1,0]
    return [-1,0] if current==[0,-1]
  end
  def canWalk?
    newy=@pos[0]+@direction[0]
    newx=@pos[1]+@direction[1]
    return true if newy < 0
    return true if newy >= @ymax
    return true if newx < 0
    return true if newx >= @xmax
    return true if @map[newy][newx] != '#'
    return false
  end
  def walk
    if ! self.canWalk? 
      @direction=directionChooser( @direction)
      return
    end
    if @pos[0] >= 0 &&
       @pos[0] <  @ymax &&
       @pos[1] >= 0 &&
       @pos[1] <  @xmax
      @map[@pos[0]][@pos[1]]="X"
      @pos[0] += @direction[0]
      @pos[1] += @direction[1]
    else
      @left_coordinate_system = true
    end
  end
  def done?
    return @left_coordinate_system
  end
  def cnt
    c=Hash.new(0)
    for y in 0..(@map.length-1)
      for x in 0..(@map[y].length-1)
        c[@map[y][x]]+=1
      end
    end
    c.keys.sort.each do |k| 
      puts "Lösung #{k}=#{c[k]}"
    end
  end
end

m=Map.new(zeilen,spalten)
m.prettyprint
m.parseInputString( inputstring)
m.prettyprint
puts m.canWalk?

while ! m.done?
  m.walk
#  m.prettyprint
end

m.cnt
