

# Zieldatenformat
#  - Startcoordinate
#  -- [Pfad, Pfad]
#  -+ Anzahl erreichbarer 9er - gemessen an der Position der 9er, nicht an der Anzahl der Routen!

# recurse(
#   [startcoord]
#   [currentcoord]
#   sum_so_far
#)


class Map
  def initialize()
    inputstr=File.read(ARGV[0])
    @ymax=inputstr.chomp.split("\n").length-1
    @ymin=0
    @xmax=inputstr.chomp.split("\n")[0].length-1
    @xmin=0
    @map=Array.new
    inputstr.chomp.split("\n").each_with_index do |line,yidx|
      @map[yidx]=Array.new
      line.split("").each_with_index do |char, xidx|
        @map[yidx][xidx]=char.to_i
      end
    end
  end
  def prettyprint
    for y in 0..@ymax
      for x in 0..@xmax
        print @map[y][x]
      end
      puts
    end
  end
  def getTrailheads
    ret=Array.new
    for y in 0..@ymax
      for x in 0..@xmax
        if @map[y][x]==0
          ret.push( [y,x] )
        end
      end
    end
  end
  def getFinishes
    ret=Array.new
    for y in 0..@ymax
      for x in 0..@xmax
        if @map[y][x]==9
          ret.push( [y,x] )
        end
      end
    end
  end
  def canClimb?( cury, curx) # => bool
    cur=@map[cury][curx]
    want=cur+1
    if cury > @ymin && @map[cury-1][curx]==want
      return true
    elsif cury < @ymax && @map[cury+1][curx]==want
      return true
    elsif curx > @xmin && @map[cury][curx-1]==want
      return true
    elsif curx < @xmax && @map[cury][curx+1]==want
      return true
    else
      return false
    end
  end
  def ascend( starty, startx, cury, curx, sum_so_far, target_coord_so_far) # => +1 für 9
    puts "Debug: Start [#{starty},#{startx}], cur=[#{cury},#{curx}]=#{@map[cury][curx]}"
    if @map[cury][curx]==9
      return [cury,curx]
    end
    if ! self.canClimb?( cury, curx)
      return []
    end
    if self.canClimb?( cury, curx)
      cur=@map[cury][curx]
      want=cur+1
      if cury > @ymin && @map[cury-1][curx]==want
        target_coord_so_far.push( self.ascend(starty, startx, cury-1, curx, sum_so_far, target_coord_so_far))
      end
      if cury < @ymax && @map[cury+1][curx]==want
        target_coord_so_far.push( self.ascend(starty, startx, cury+1, curx, sum_so_far, target_coord_so_far))
      end
      if curx > @xmin && @map[cury][curx-1]==want
        target_coord_so_far.push( self.ascend(starty, startx, cury, curx-1, sum_so_far, target_coord_so_far))
      end
      if curx < @xmax && @map[cury][curx+1]==want
        target_coord_so_far.push( self.ascend(starty, startx, cury, curx+1, sum_so_far, target_coord_so_far))
      end
    end
    return target_coord_so_far
  end
end

m=Map.new
res=m.ascend(0,0, 0,0, 0, [])
#puts "Res=", res.filter{ |a| a.length>0}.inspect
puts "Res=", res.inspect

puts [].inspect
