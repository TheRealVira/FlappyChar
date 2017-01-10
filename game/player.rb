# Represents the player
class Player
	attr_accessor :alive, :position, :lastPosition, :velocity, :playerC_D, :playerC_U, :points, :lastTickPoints, :firstTimeDrawing, :inputWindow
	
	# Initializes the player
	def initialize(rows)
		@alive = true
		@position = rows / 2
		@lastPosition = @position
		@velocity = 0
		@playerC_D = "W"
		@playerC_U = "M"
		@points = 0
		@lastTickPoints = @points
		@firstTimeDrawing = true
		
		@inputWindow = Curses::Window.new(0,0,1,1)
		@inputWindow.box(" ", " ")
		@inputWindow.setpos(-1, -1)
		@inputWindow.refresh
		@inputWindow.nodelay=true
	end
	
	def shouldJump?
		return @inputWindow.getch == " "
	end
	
	# Moves the tubes
	def update(rows)
		if shouldJump?
			@velocity = 1.35
		end
	
		@lastPosition = @position
		@position = position + @velocity
		@velocity = @velocity - 0.35
		
		if @position > rows - 1
			@position = rows - 1
		end
		
		# Touching the floor flooded with lava is never good
		if @position < 1
			@position = 1
			@alive = false
		end
	end
	
	# Draws the player
	def draw(cols, rows)
		Curses.attrset(Curses.color_pair(4) | Curses::A_NORMAL)
		Curses.setpos(rows - @lastPosition, cols / 2.0)
		Curses.addstr(" ")
		
		Curses.attrset(Curses.color_pair(3) | Curses::A_NORMAL)
		Curses.setpos(rows - @position, cols / 2.0)
		Curses.addstr(@velocity < -0.1 ? @playerC_D : playerC_U)
		
		if @lastTickPoints != @points || @firstTimeDrawing
			@firstTimeDrawing = false
			Curses.attrset(Curses.color_pair(2) | Curses::A_NORMAL)
			Curses.setpos(0, 0)
			Curses.addstr(("Points:  " + @points.to_s).center(cols))
			@lastTickPoints = @points
		end
	end
end