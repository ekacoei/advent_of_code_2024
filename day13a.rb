

# //targetx, targety, ax, ay, bx, by

inputstr=File.read(ARGV[0])
single_text_array=inputstr.split("\n\n")

puzzlesum=0

single_text_array.each do | sta|
  m = sta.match /Button A: X(?<ax>[-+]\d+), Y(?<ay>[-+]\d+)/ 
#  puts "Button A: X#{m[:ax]}, Y#{m[:ay]}"
  ax=m[:ax].to_i
  ay=m[:ay].to_i
  m = sta.match /Button B: X(?<bx>[-+]\d+), Y(?<by>[-+]\d+)/
#  puts "Button B: X#{m[:bx]}, Y#{m[:by]}"
  bx=m[:bx].to_i
  by=m[:by].to_i
  m = sta.match /Prize: X=(?<targetx>\d+), Y=(?<targety>\d+)/
#  puts "Prize: X=#{m[:targetx]}, Y=#{m[:targety]}"
  targetx=m[:targetx].to_i
  targety=m[:targety].to_i

#  [ax,ay,bx,by,targetx,targety].each do |var|
#    puts var.inspect
#  end

  token_req=3*100+100
  solveable=false
  for a in 0..100
    for b in 0..100
      x=a*ax + b*bx
      y=a*ay + b*by
#      puts "Trying a=#{a} b=#{b}, tx=#{targetx}, cx=#{x}, ty=#{targety}, cy=#{y}"
      if targetx == x &&
         targety == y
        solveable=true
        thisprice=3*a+b
        if thisprice < token_req
          token_req = thisprice
        end
      end
    end
  end
  if solveable
    puts "Button A: X#{ax}, Y#{ay}"
    puts "Button B: X#{bx}, Y#{by}"
    puts "Prize: X=#{targetx}, Y=#{targety}"
    puts "Ist lösbar für #{token_req}"
    puzzlesum += token_req
  end
end

puts "Puzzlelösung = #{puzzlesum}"
