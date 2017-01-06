# Represents the tubes (the obstacles, that the player has to avoid)
class Tubes
	attr_accessor :holeSize, :holeHeight, :tubePosition, :velocity, :passed
	
	# Initializes the tubes
	def initialize(cols, rows)
		reset(cols, rows)
		
		@velocity = -1.5
	end
	
	# Moves the tubes
	def update(cols, rows)
		@tubePosition = @tubePosition + @velocity
		
		if @tubePosition < 0
			reset(cols, rows)
		end
	end
	
	# Draws the tubes
	def draw(rows)
		$i = 0
		Curses.attrset(Curses.color_pair(1) | Curses::A_NORMAL)
		
		while $i < rows - 1
			$i = $i + 1
			
			if $i.between?(@holeHeight, @holeHeight + @holeSize)
				next
			end
			
			Curses.setpos($i, @tubePosition)
			Curses.addstr("00")
		end
	end
	
	# True: the player is inside one of the tubes / touches one of the tubes
	def didHit(pos)
		return !pos.between?(@holeHeight, @holeHeight + @holeSize)
	end
	
	# Resets the position of the tubes and assigns random values to the hole
	def reset(cols, rows)
		@holeSize = 4 + rand(2)
		@holeHeight = rows/4 + rand(rows/2)
		@tubePosition = cols
		@passed = false
	end
end