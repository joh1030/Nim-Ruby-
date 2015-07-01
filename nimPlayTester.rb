#!/usr/bin/env ruby
require "./nim.rb"

class NimPlayerTester
	def initialize(game)
		@game = game
	end
	def game
		@game
	end
end
run = 0
while run < 20
	autoNim = NimPlayerTester.new(Nim.new(Player.new, Player.new))
	autoNim.game.autoConfigBoard
	autoNim.game.player_choice=(0) #dumb player starts first
	while autoNim.game.gameOver == false
		autoNim.game.autoComputerMakeMove()
		if autoNim.game.player_choice == 0
			puts "Dumb player took #{autoNim.game.sticks_taken} from row #{autoNim.game.row}"
			puts
		else
			puts "Smart player took #{autoNim.game.sticks_taken} from row #{autoNim.game.row}"
			puts
		end
		autoNim.game.checkGameOver()
		if autoNim.game.gameOver == true
			if autoNim.game.player_choice == 0 
				puts "Dumb player wins!!!"
			else
				puts "Smart player wins!!!"
			end
		end
		autoNim.game.player_choice=((autoNim.game.player_choice + 1) % 2)
	end
	run += 1
	puts
end
puts "Thanks for playing! Good bye!!!"