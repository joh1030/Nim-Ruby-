require 'minitest/autorun'
load 'nim.rb'

class NimTester < MiniTest::Unit::TestCase
	#initialize class object
	def setup
		@Nim = Nim.new(Player.new)
		#player is smart computer player by default
	end
	def test_kernel_state_after_move
		@Nim.computerMakeMove()
		board = @Nim.board
		#after smart computer makes the move, check_kernel_state should return true
		assert_equal(true, @Nim.object.check_kernel_state(board))
	end
	#Test kernel state of different board configurations
	def test_kernel_state
		assert_equal(false, @Nim.object.check_kernel_state([1,4,5,7]))
		assert_equal(true, @Nim.object.check_kernel_state([1,3,5,7]))
		assert_equal(true, @Nim.object.check_kernel_state([4, 3, 7]))
	end
end