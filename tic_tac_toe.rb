# frozen_string_literal: true

# The main event of game
class Game
  attr_accessor :board, :player1, :player2

  def initialize
    @board = Board.new
    @player1 = Player.new
    @player2 = Player.new('Player-2', 'X')
    @winner = nil
  end

  def run
    intro
    round
    outro
  end

  def round
    until game_over?
      column_index, row_index = prompt_user(@player1)
      next unless valid?(row_index, column_index)

      process_turn(@player1, row_index, column_index)
      break if game_over?

      column_index, row_index = prompt_user(@player2)
      next unless valid?(row_index, column_index)

      process_turn(@player2, row_index, column_index)
      break if game_over?
    end
  end

  def game_over?
    horizontal_check || vertical_check || diagonal_check || full?
  end

  private

  attr_accessor :game_over, :winner

  def intro
    puts 'The game has began.'
    puts 'Choose a point by type in a number between 0 and 2.'
    puts "\n\n"
  end

  def valid?(row, col)
    row.between?(0, 2) && col.between?(0, 2) && @board.layout[row][col] == ' '
  end

  def process_turn(player, row_index, column_index)
    player.draw_point(@board, row_index, column_index)
    @board.render_board
  end

  def outro
    puts 'Thank you for playing.'
    puts @winner.nil? ? 'Tie game.' : "The winner is #{winner.name}."
  end

  def prompt_user(user)
    puts "#{user.name} please select a row."

    row_index = gets.to_i

    puts "#{user.name} please select a column."

    column_index = gets.to_i

    [column_index, row_index]
  end

  def horizontal_check
    @board.layout.each do |row|
      if row.all?('O') || row.all?('X')
        @winner = row[0] == 'O' ? @player1 : @player2

        return true
      end
    end

    false
  end

  def vertical_check
    slot = @board.layout

    3.times do |i|
      col = [slot[0][i], slot[1][i], slot[2][i]]

      next unless col.all?('O') || col.all?('X')

      @winner = col[0] == 'O' ? @player1 : @player2

      return true
    end

    false
  end

  def diagonal_check
    slot = @board.layout
    diagonal1 = []
    diagonal2 = []

    3.times do |i|
      diagonal1 << slot[i][i]
      diagonal2 << slot[2 - i][i]
    end

    if diagonal1.all?('O') || diagonal1.all?('X')
      @winner = diagonal1[0] == 'O' ? @player1 : @player2

      return true
    elsif diagonal2.all?('O') || diagonal2.all?('X')
      @winner = diagonal1[0] == 'O' ? @player1 : @player2

      return true
    end

    false
  end

  def full?
    !@board.layout.flatten.include?(' ')
  end
end

# The board where the marks are drawn
class Board
  attr_accessor :layout

  def initialize
    @layout = Array.new(3) { Array.new(3, ' ') }
  end

  def render_board
    puts "\n"
    @layout.each { |row| p row }
    puts "\n"
  end
end

# User who could insert point on board
class Player
  attr_reader :name, :draw_symbol

  def initialize(name = 'Player-1', draw_symbol = 'O')
    @name = name
    @draw_symbol = draw_symbol
  end

  def draw_point(board, row_index, column_index)
    board.layout[row_index][column_index] = @draw_symbol
  end
end
