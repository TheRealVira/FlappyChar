# Represents the main game class
class Game
	attr_accessor :rows, :cols, :thxForPlaying, :tubes, :player, :mainGameThread, :lastHighscore
	
	# Starting routine
	def start(highscore)
		
		@rows = Curses.lines
		@cols = Curses.cols
		
		@thxForPlaying = "Thx for playing!"
		
		tubes1 = Tubes.new(@cols, @rows)
		tubes2 = Tubes.new(@cols / 2.0 - 2, @rows)
		tubes2.passed = true	# no cheater points here... ;)
		
		@tubes = [tubes1, tubes2]
		
		@player = Player.new(@rows)
		@lastHighscore = highscore + 0
		
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
		@tubes.each do |t|
			# Update the obstacle
			t.update(@cols, @rows)
			
			# Check if the obstacle is going to pass the player
			if !t.passed && t.tubePosition < @cols / 2.0
				# Does the player hit the obstacle?
				if t.didHit(@rows - @player.position)
					# If so, he dies.
					@player.alive = false
					
					endGame
					return
				end
				
				t.passed = true
				@player.points = @player.points + 1
				
				if @player.points > @lastHighscore
					@lastHighscore = @player.points
				end
			end
		end
		
		@player.update(@rows)
	end
	
	#=============
	#== DRAWING ==
	#=============
	def draw
		# Clear the screen with a sky color
		Curses.clear
		Curses.attrset(Curses.color_pair(4) | Curses::A_NORMAL)
		Curses.setpos(1, 0)
		Curses.addstr((" " * @cols) * @rows)
		
		# Draw all other elements
		@player.draw(@cols, @rows)
		
		@tubes.each do |t|
			t.draw(@rows)
		end
	end
	
	# Ending routine
	def endGame
		myMenu = Menu.new(@lastHighscore)
		
		#exit threads
		@player.playerThread.kill
		@mainGameThread.kill
	end
end