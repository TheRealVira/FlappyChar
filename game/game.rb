# Represents the main game class
class Game
	attr_accessor :rows, :cols, :thxForPlaying, :tubes, :player, :lastHighscore, :hCenter, :endedTheGame, :firstTimeDrawing
	
	# Starting routine
	def start(highscore)
		
		@rows = Curses.lines
		@cols = Curses.cols
		@hCenter = @cols / 2.0
		
		@thxForPlaying = "Thx for playing!"
		
		tubes1 = Tubes.new(@cols, @rows)
		tubes2 = Tubes.new(@cols / 2.0 - 2, @rows)
		tubes2.passed = true	# no cheater points here... ;)
		
		@tubes = [tubes1, tubes2]
		
		@player = Player.new(@rows)
		@lastHighscore = highscore + 0
		
		@endedTheGame = false
		@firstTimeDrawing = true
		
		main
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
			
			if t.passed
				next
			end
			
			# Check if the obstacle has passed
			if t.tubePosition + t.tubeWidth < @hCenter
				# Does the player hit the obstacle?
				
				t.passed = true
				@player.points = @player.points + 1
				
				if @player.points > @lastHighscore
					@lastHighscore = @player.points
				end
			# Check if the obstacle is passing
			elsif t.tubePosition <= @hCenter && t.tubePosition + t.tubeWidth >= @hCenter
				if t.didHit(@rows - @player.position - 1)
					# If so, he dies.
					
					@player.alive = false
					
					endGame
					return
				end
			end
		end
		
		@player.update(@rows)
	end
	
	#=============
	#== DRAWING ==
	#=============
	def draw
		if @firstTimeDrawing # Clear the screen with a sky color
			@firstTimeDrawing = false
			Curses.attrset(Curses.color_pair(4) | Curses::A_NORMAL)
			Curses.setpos(1, 0)
			Curses.addstr((" " * @cols) * @rows)
		end
		
		# Draw all other elements
		@player.draw(@cols, @rows)
		
		@tubes.each do |t|
			t.draw(@rows, @cols)
		end
	end
	
	# Ending routine
	def endGame
		if @endedTheGame
			return
		end
	
		@endedTheGame = true
		@player.inputWindow.close
		myMenu = Menu.new(@lastHighscore)
	end
end