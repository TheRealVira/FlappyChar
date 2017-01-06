# Represents the player
class Player
	attr_accessor :alive, :position, :velocity, :playerC, :playerThread, :points
	
	# Initializes the player
	def initialize(rows)
		@alive = true
		@position = rows/2
		@velocity = 0
		@playerC = "W"
		@points = 0
		
		@playerThread = Thread.new{inputR()}
	end
	
	# Background input routine
	def inputR
		while @alive
			if shouldJump?
				@velocity = 1
			end
			
			sleep(1.0/100.0)
		end
	end
	
	def shouldJump?
		return STDIN.getc == ' '
	end
	
	# Moves the tubes
	def update(rows)
		@position = position + @velocity
		@velocity = @velocity - 0.35
		
		if @velocity == 0
			@velocity = 0
		end
		
		if @position > rows - 1
			@position = rows
		end
		
		# Touching the floor flooded with lava is never good
		if @position < 1
			@alive = false
		end
	end
	
	# Draws the player
	def draw(cols, rows)
		Curses.attrset(Curses.color_pair(3) | Curses::A_NORMAL)
		Curses.setpos(rows - @position, cols / 2.0)
		Curses.addstr(@playerC)
		
		Curses.attrset(Curses.color_pair(2) | Curses::A_NORMAL)
		Curses.setpos(0, 0)
		Curses.addstr(("Points:  "+@points.to_s).center(cols))
	end
end