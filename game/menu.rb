# Represents the main menu
class Menu
	attr_accessor :menuWindow, :highscore
	
	# Initializes the main menu
	def initialize(newHighscore)
		@menuWindow = Curses::Window.new(
						0,	# Height
						0,	# Width
                        0,	# Top
                        0 )	# Left
						
		@menuWindow.box("|", "-")
		@menuWindow.setpos(1, 1)
		@menuWindow.refresh
		@highscore = newHighscore
		
		draw
		
		while ch = @menuWindow.getch
			case ch
			when 's'
				myGame = Game.new
				@menuWindow.close
				myGame.start(@highscore)
				return
			when 'x'
				Curses.close_screen
				return
			end
		end
	end
	
	# Draws the main menu
	def draw
		@menuWindow.setpos(1, 0)
		@menuWindow.attrset(Curses::A_NORMAL)
		
		# FlappyChar
		@menuWindow.addstr(" _____ _                 _____ _           ".center(Curses.cols))
		@menuWindow.addstr("|   __| |___ ___ ___ _ _|     | |_ ___ ___ ".center(Curses.cols))
		@menuWindow.addstr("|   __| | .'| . | . | | |   --|   | .'|  _|".center(Curses.cols))
		@menuWindow.addstr("|__|  |_|__,|  _|  _|_  |_____|_|_|__,|_|  ".center(Curses.cols))
		@menuWindow.addstr("            |_| |_| |___|                  ".center(Curses.cols))
	
		@menuWindow.setpos(Curses.lines / 2, 0)
		@menuWindow.addstr("Press 's' to start...".center(Curses.cols))
		
		@menuWindow.setpos(Curses.lines - 2, 0)
		@menuWindow.addstr("Press 'x' to exit   ".rjust(Curses.cols))
		
		@menuWindow.attrset(Curses::A_STANDOUT)
		@menuWindow.setpos(Curses.lines - 2, 3)
		@menuWindow.addstr("Highscore:  " + (@highscore.to_s))
	end
end