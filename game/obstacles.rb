# Represents the tubes (the obstacles, that the player has to avoid)
class Tubes
	attr_accessor :holeSize, :holeHeight, :tubePosition, :lastPosition, :tubeWidth, :velocity, :passed, :dontDraw
	
	# Initializes the tubes
	def initialize(cols, rows)
		@velocity = -1.5
		@tubeWidth = 3
		
		@dontDraw = true
		reset(cols, rows)
		@dontDraw = false
	end
	
	# Moves the tubes
	def update(cols, rows)
		@lastPosition = @tubePosition
		@tubePosition = @tubePosition + @velocity
		
		if @tubePosition < 1
			@dontDraw = true
			drawIntern(rows, cols, @lastPosition, true)
			reset(cols, rows)
			@dontDraw = false
		end
	end
	
	# Draws the tubes
	def draw(rows, cols)
		if @dontDraw
			return
		end
		
		drawIntern(rows, cols, @lastPosition, true)
		drawIntern(rows, cols, @tubePosition, false)
	end
	
	def drawIntern(rows, cols, pos, clear)
		$i = 0
		$w = (pos + @tubeWidth > cols) ? (cols - pos + @tubeWidth) : @tubeWidth
		
		Curses.attrset(clear ? Curses.color_pair(4) : Curses.color_pair(1) | Curses::A_NORMAL)
		
		while $i < rows - 1
			$i = $i + 1
			
			if $i.between?(@holeHeight, @holeHeight + @holeSize + 1)
				next
			end
			
			Curses.setpos($i, pos)
			Curses.addstr(clear ? " " * $w : "0" * $w)
		end
	end
	
	# True: the player is inside one of the tubes / touches one of the tubes
	def didHit(pos)
		return !pos.between?(@holeHeight, @holeHeight + @holeSize)
	end
	
	# Resets the position of the tubes and assigns random values to the hole
	def reset(cols, rows)
		@holeSize = 3 + rand(2)
		@holeHeight = rows / 4 + rand * (rows / 2)
		@tubePosition = cols - 1
		@lastPosition = @tubePosition
		@passed = false
	end
end