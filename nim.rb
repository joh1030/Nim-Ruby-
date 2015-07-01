#!/usr/bin/env ruby

# Nim Game (normal play)
# Rules: Two players take turns taking sticks and who takes the last stick wins! Each player can take as many sticks
# as he/she wants but ONLY from the same row.

class Nim
	def initialize(* args)
		#check for number of arguments; essentially overriding constructor
		if args.size() == 1
			@object = args[0]
		elsif args.size() == 2
			@dumb_player = args[0]
			@smart_player = args[1]
		else
			puts "Invalid number of arguments!"
		end
		@board_choice = 1 # by default
		@player_choice = 1 # by default
		@config1 = [1, 3, 5 ,7]
		@config2 = [4, 3, 7]
		@row_num
		@num_sticks
		@board=[]
		@gameOver = false
		@sticks_taken
		@row
	end
	def board
		@board
	end
	def object
		@object
	end
	def sticks_taken
		@sticks_taken
	end
	def row
		@row
	end
	def board_choice
		@board_choice
	end
	def player_choice
		@player_choice
	end
	def player_choice=(pc)
		@player_choice = pc
	end
	def start_game()
		puts "Welcome to NIM!"
		puts "1: [1, 3, 5, 7]"
		puts "2: [4, 3, 7]"
		print "Select board configuration (1 or 2): "
		@board_choice = gets.chomp.to_i
		while @board_choice != 1 && @board_choice != 2
			print "Invalid Selection! Select between 1 and 2: "
			@board_choice = gets.chomp.to_i
		end
		puts
		@object.displayMethods()
		print "Select computer player (1 or 2): "
		@player_choice = gets.chomp.to_i
		while @player_choice != 1 && @player_choice != 2
			print "Invalid Selection! Select between 1 and 2: "
			@player_choice = gets.chomp.to_i
		end
		puts
	end
	def checkGameOver()
		sum = 0
		@board.each do |num|
			sum += num
		end
		if sum == 0
			@gameOver = true
		end
	end
	def computerMakeMove()
		if @player_choice == 1
			@board = @object.computer_player_smart(@board)
		else	
			@board = @object.computer_player_dumb(@board)
		end
		checkGameOver()
	end
	# for auto play
	def autoComputerMakeMove()
		if @player_choice == 1
			@board = @smart_player.computer_player_smart(@board)
			@sticks_taken = @smart_player.sticks_taken
			@row = @smart_player.row
		else	
			@board = @dumb_player.computer_player_dumb(@board)
			@sticks_taken = @dumb_player.sticks_taken
			@row = @dumb_player.row
		end
	end
	def configBoard
		if @board_choice == 1
			@board = @config1
		else
			@board = @config2
		end
	end
	# for auto play
	def autoConfigBoard
		@board = @config1
	end
	def display()
		row_num = 1
		@board.each do |num|
				print "Row #{row_num}: "
				while num > 0
					print "X"
					num = num - 1
				end
				puts
				row_num += 1
		end
	end
	def humanMakeMove()
		print "Select the row(1-#{@board.size()}): "
		row = gets.chomp.to_i
		while row > @board.size() || row == 0 || @board.at(row-1) == 0
			if @board.at(row-1) == 0
				print "There aren't any more sticks in the row. Select a different row: "
				row = gets.chomp.to_i
			else
				print "Invalid row. Select valid row: "
				row = gets.chomp.to_i
			end
		end
		num_at_row = @board.at(row-1)
		if num_at_row == 1
			print "Select the number of sticks (1): "
		else
			print "Select number of sticks (1-#{num_at_row}): "
		end
		num_sticks = gets.chomp.to_i
		while num_sticks > num_at_row || num_sticks == 0
			print "Invalid number of sticks. Select a valid number of sticks (1-#{num_at_row}): "
			num_sticks = gets.chomp.to_i
		end
		num_at_row = num_at_row - num_sticks
		@board.delete_at(row-1)
		@board.insert(row-1, num_at_row)
		puts
	end
	def gameOver
		@gameOver
	end
end

class Player
	def initialize()
		@parity = []
		@binary_board = []
		@sticks_taken
		@row
	end
	def sticks_taken
		@sticks_taken
	end
	def row
		@row
	end
	def computer_player_smart(board)
        #check to see if you are already in kernel state
        #if you are out of kernel state, get back in kernel state
        for row_index in 0..(board.size-1)
            temp_board = board.dup
            sticks_to_take = temp_board[row_index]
			@sticks_taken = 0
            while sticks_to_take > 0
                sticks_to_take -= 1
				@sticks_taken += 1
                temp_board.delete_at(row_index)
                temp_board.insert(row_index, sticks_to_take)
                if check_kernel_state(temp_board)
					@row = row_index + 1
					#puts "smart row: #{@row}"
					#puts "smart sticks: #{@sticks_taken}"
                    return temp_board
                end
            end
        end
	end
	
    def computer_player_dumb(board)
		row = rand(0..board.size-1)
		while board.at(row) == 0
			row = rand(0..board.size-1)
		end
		num_sticks = rand(1..board.at(row))
		@row = row + 1
		@sticks_taken = num_sticks
		num_sticks = board.at(row) - num_sticks
		board.delete_at(row)
		board.insert(row, num_sticks)
		return board
	end
    # check for kernel state; if 1 in parity, non-kernel state. If all 0's, kernel state
    def check_kernel_state(board)
		@parity = []
		@binary_board = []
        #convert number of sticks into binary and store in array
        board.each do |number_of_sticks|
            #temp_num_sticks = number_of_sticks.to_s(2) #converts to binary
            temp_num_sticks = '%0*b' % [4, number_of_sticks]
            @binary_board << temp_num_sticks #add string to binary array
        end
        #find @parity of each column
        for index in 0..3
			num_ones = 0
            @binary_board.each do |binary_number|
				if binary_number[index].to_i == 1
					num_ones += 1
				end
			end
			if (num_ones % 2) == 0
				@parity << 0
			else
				@parity << 1
			end
		end
		if @parity.include? 1
		  return false
		else
		  return true
		end
    end
        
	def displayMethods()
		o = self
		count = 1
		o.methods.each do |method|
			if(method.to_s[0..14] == "computer_player")
				puts "#{count}: #{method.to_s}"
				count += 1
			end
		end
	end
end

# only execute when the script is run directly
if __FILE__ == $0
	nim = Nim.new(Player.new)
	nim.start_game
	nim.configBoard
	while nim.gameOver == false
		nim.display
		nim.humanMakeMove
		nim.checkGameOver
		if nim.gameOver == false
			nim.computerMakeMove
			if nim.gameOver == true
				puts "Computer player wins!"
			end
		else
			puts "Human player wins!"
		end
	end
end