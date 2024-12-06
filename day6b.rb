
# Tag6b
# Das Hindernis muss sich entlang der Route aus Teil 6a befinden.
# Die Startposition wird als Hindernis ausgeschlossen

# Billig-Kreiserkennung - wenn der Wächter ein Feld dreimal passiert, ist es ein Loop

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
    @loop=false
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
          self.walk
#          @map[y][x]="."
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
    return true if @map[newy][newx] != '#' && @map[newy][newx] != 'O'
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
      @map[@pos[0]][@pos[1]]="5" if @map[@pos[0]][@pos[1]]=="4" 
      @map[@pos[0]][@pos[1]]="4" if @map[@pos[0]][@pos[1]]=="3" 
      @map[@pos[0]][@pos[1]]="3" if @map[@pos[0]][@pos[1]]=="2" 
      @map[@pos[0]][@pos[1]]="2" if @map[@pos[0]][@pos[1]]=="1"
      @map[@pos[0]][@pos[1]]="1" if @map[@pos[0]][@pos[1]]=="." 
      if @map[@pos[0]][@pos[1]]=="4"
        @loop = true
        return
      end
      @pos[0] += @direction[0]
      @pos[1] += @direction[1]
    else
      @left_coordinate_system = true
    end
  end
  def done?
    return @left_coordinate_system || @loop
  end
  def loop?
    return @loop
  end
  def left?
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
  def genLoopCandidateList
    ret=Array.new
    for y in 0..(@map.length-1)
      for x in 0..(@map[y].length-1)
        if @map[y][x] == "1" || @map[y][x] == "2" || @map[y][x] == "3" || @map[y][x] == "4" || @map[y][x] == "5"
          candidates=[y,x]
          ret=ret.push(candidates)
        end
      end
    end
    return ret
  end
  def setObstacle(y, x)
    @map[y][x]='O'
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

puts "Labyrinth verlassen" if m.left?
puts "Im Kreis gelaufen  " if m.loop?
m.cnt

loopCandidates=m.genLoopCandidateList

puts "Mögliche Kandidaten für Hindernisse #{loopCandidates.inspect}"

puzzlelösung=0

generalMap = Map.new(zeilen,spalten)
generalMap.parseInputString( inputstring)
loopCandidates.each do |yxpair|
  puts "Trying Obstacle at #{yxpair}"
#https://stackoverflow.com/questions/8206523/how-to-create-a-deep-copy-of-an-object-in-ruby
#deep copy
  localMap=Marshal.load(Marshal.dump(generalMap))
#  puts localMap.class
  localMap.setObstacle( yxpair[0], yxpair[1] )
#  localMap.prettyprint
  while ! localMap.done?
    localMap.walk
  end
#  puts "Labyrinth verlassen" if localMap.left?
#  puts "Im Kreis gelaufen  " if localMap.loop?

  if localMap.loop?
    preview=Marshal.load(Marshal.dump(generalMap))
    preview.setObstacle( yxpair[0], yxpair[1] )
    puts "Im Kreis gelaufen:"
    preview.prettyprint
    localMap.prettyprint
    puzzlelösung += 1
  end
end

puts "Puzzlelösung = #{puzzlelösung}"
