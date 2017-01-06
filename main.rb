require 'colorize'
require 'curses'

require_relative 'obstacles'
require_relative 'player'

# Represents the main game class
class Game
	attr_accessor :rows, :cols, :thxForPlaying, :tubes1, :tubes2, :player, :mainGameThread
	
	# Starting routine
	def start
		Curses.init_screen
		Curses.start_color	# Enable colors
		Curses.curs_set(0)  # Invisible cursor
		Curses.init_pair(1, Curses::COLOR_WHITE, Curses::COLOR_GREEN) # Tubes
		Curses.init_pair(2, Curses::COLOR_RED, Curses::COLOR_BLACK) # Default
		Curses.init_pair(3, Curses::COLOR_WHITE, Curses::COLOR_CYAN) # Player
		Curses.init_pair(4, Curses::COLOR_CYAN, Curses::COLOR_CYAN) # Background
		
		@rows = Curses.lines
		@cols = Curses.cols
		
		
		@thxForPlaying = "Thx for playing!"
		
		@tubes1 = Tubes.new(@cols, @rows)
		@tubes2 = Tubes.new(@cols / 2.0 - 2, @rows)
		@tubes2.passed = true	# no cheater points here... ;)
		
		@player = Player.new(@rows)
		
		Thread.abort_on_exception = true
		@mainGameThread = Thread.new{main}
		@mainGameThread.join
		@player.playerThread.join
		
		Curses.clear
	end
	
	# Main game loop logic routine
	def main
		while @player.alive
			update
			draw
			
			Curses.refresh
			
			sleep(1.0/10.0)
		end
		
		endGame
	end
	
	#===============
	#== UPDATING ===
	#===============
	def update
		# Update the tubes before the player
		@tubes1.update(@cols, @rows)
		
		@tubes2.update(@cols, @rows)
		
		@player.update(@rows)
		
		# TODO: Think about a way to reduce duplicated code...
		
		# Check if the first obstacle is going to pass the player
		if !@tubes1.passed && @tubes1.tubePosition < @cols / 2.0
			# Does the player hit the obstacle?
			if @tubes1.didHit(@rows - @player.position)
				# If so, he dies.
				@player.alive = false
				return
			end
			
			@tubes1.passed = true
			@player.points = @player.points + 1
		end
		
		# Check if the second obstacle is going to pass the player
		if !@tubes2.passed && @tubes2.tubePosition < @cols / 2.0
			# Does the player hit the obstacle?
			if @tubes2.didHit(@rows - @player.position)
				# If so, he dies.
				@player.alive = false
				return
			end
			
			@tubes2.passed = true
			@player.points = @player.points + 1
		end
	end
	
	#=============
	#== DRAWING ==
	#=============
	def draw
		# Clear the screen with a sky color
		Curses.clear
		Curses.attrset(Curses.color_pair(4) | Curses::A_NORMAL)
		Curses.setpos(1, 0)
		Curses.addstr((" "*@cols)*@rows)
		
		# Draw all other elements
		@player.draw(@cols, @rows)
		
		@tubes1.draw(@rows)
		
		@tubes2.draw(@rows)
	end
	
	# Ending routine
	def endGame
		#exit threads
		@mainGameThread.kill
		@player.playerThread.kill
	
		# Print some nice last words on the center of the screen
		sleep 1
		
		
		Curses.close_screen
		
	end
end

# Starting the game
puts "Starting game..."
myGame = Game.new
myGame.start