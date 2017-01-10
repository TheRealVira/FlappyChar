require 'curses'
require 'io/console'

require_relative 'obstacles'
require_relative 'player'
require_relative 'game'
require_relative 'menu'
require_relative 'getKey'

# Initialize curses

Curses.init_screen
Curses.start_color	# Enable colors
Curses.curs_set(0)  # Invisible cursor
Curses.noecho		# Turn off echo
Curses.init_pair(1, Curses::COLOR_WHITE, Curses::COLOR_GREEN)	# Tubes
Curses.init_pair(2, Curses::COLOR_RED, Curses::COLOR_WHITE)		# Points
Curses.init_pair(3, Curses::COLOR_WHITE, Curses::COLOR_CYAN)	# Player
Curses.init_pair(4, Curses::COLOR_CYAN, Curses::COLOR_CYAN)		# Background
Curses.init_pair(5, Curses::COLOR_WHITE, Curses::COLOR_BLACK)	# Default

Thread.abort_on_exception = true

# Loading up the menu
myMenu = Menu.new(0)