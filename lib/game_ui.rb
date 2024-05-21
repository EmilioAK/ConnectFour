# frozen_string_literal: true

class GameUI
  def initialize(game)
    @game = game.new
  end

  def play
    until @game.winner
      display_board
      puts "Current player: #{@game.current_player}"
      column = get_column
      @game.place_chip(column)
    end

    display_board
    puts game_result
  end

  private

  def display_board
    rotated_board = rotate_board(@game.board)
    rotated_board.each do |row|
      puts row.map { |cell| cell.nil? ? '.' : cell }.join(' ')
    end
  end

  def rotate_board(board)
    board.transpose.reverse
  end

  def get_column
    loop do
      print "Enter the column (0-6) to place your chip: "
      input = gets.chomp
      if valid_column?(input)
        return input.to_i
      else
        puts "Invalid input. Please enter a number between 0 and 6."
      end
    end
  end

  def valid_column?(input)
    input.match?(/^\d$/) && input.to_i.between?(0, 6)
  end

  def game_result
    case @game.winner
    when 'Y'
      "Yellow wins!"
    when 'R'
      "Red wins!"
    when 'T'
      "It's a tie!"
    else
      "Game over!"
    end
  end
end