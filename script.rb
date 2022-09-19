class Game
	# probably where the main game loop located
	# where the outcome is decided
end

class Board
	# render layout, store inputs from players
	attr_accessor :layout
  def initialize
    @layout = Array.new(3) {Array.new(3, "")}
  end

	def render_board
		@layout.each_with_index do |row, i|
			row.each_with_index do |column, j|
				puts @layout[i][j]
			end
		end
	end
end

class Player
	# provide input into the board
	
	def initialize(draw_symbol="X")
    @draw_symbol = draw_symbol
  end

	def draw_point(board, row_index, column_index)
    board[row_index][column_index] = @draw_symbol
	end
end

board = Board.new
player1 = Player.new
player2 = Player.new("O")
board.render_board