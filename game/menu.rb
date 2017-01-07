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
			when ' '
				myGame = Game.new
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
		@menuWindow.setpos(1, 10)
		@menuWindow.attrset(Curses::A_NORMAL)
		
		# FlappyChar
		@menuWindow.addstr(" _____ _                 _____ _\n          |   __| |___ ___ ___ _ _|     | |_ ___ ___ \n          |   __| | .'| . | . | | |   --|   | .'|  _|\n          |__|  |_|__,|  _|  _|_  |_____|_|_|__,|_|  \n                      |_| |_| |___|                  ")
	
		@menuWindow.setpos(Curses.lines / 2, 0)
		@menuWindow.addstr("Press SPACE to start...".center(Curses.cols))
		
		@menuWindow.setpos(Curses.lines - 2, 0)
		@menuWindow.addstr("Press 'x' to exit".center(Curses.cols))
		
		@menuWindow.attrset(Curses::A_STANDOUT)
		@menuWindow.setpos(Curses.lines - 2, 3)
		@menuWindow.addstr("Highscore:  " + (@highscore.to_s))
		
	end
end