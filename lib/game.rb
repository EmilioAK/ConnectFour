# frozen_string_literal: true

class Game
  attr_reader :board, :current_player, :winner
  def initialize(board = Array.new(7) { Array.new(6) }, current_player = 'Y')
    @board = board
    @current_player = current_player
    @winner = nil
  end

  def place_chip(column)
    return unless @winner.nil? && column.between?(0, @board.length - 1)

    row = @board[column].index(nil)
    return unless row

    @board[column][row] = @current_player
    assign_winner(column, row)
    update_player
  end

  private

  def assign_winner(column, row)
    @winner = current_player if winning_col?(column, row) ||
                                winning_row?(column, row) ||
                                winning_diag?(column, row)
    @winner = 'T' if full_board?
  end

  def full_board?
    @board.all? { |column| column.all? { |cell| !cell.nil? } }
  end

  def four_in_a_row?(array, index)
    cell = array[index]
    return false if cell.nil?

    start_index = [index - 3, 0].max
    end_index = [index + 3, array.length - 1].min

    slice = array[start_index..end_index]

    slice.each_cons(4).any? { |cons| cons.all? { |e| e == cell } }
  end

  def winning_col?(column, row)
    four_in_a_row?(@board[column], row)
  end

  def winning_row?(column, row)
    four_in_a_row?(board.transpose[row], column)
  end

  def winning_diag?(column, row)
    # Top-left to bottom-right diagonal (↘)
    top_left_to_bottom_right = collect_diagonal(column, row, -1, -1) + [@board[column][row]] + collect_diagonal(column, row, 1, 1)

    # Bottom-left to top-right diagonal (↗)
    bottom_left_to_top_right = collect_diagonal(column, row, -1, 1) + [@board[column][row]] + collect_diagonal(column, row, 1, -1)

    # Check if any of the diagonals have four in a row
    four_in_a_row?(top_left_to_bottom_right, top_left_to_bottom_right.size / 2) ||
      four_in_a_row?(bottom_left_to_top_right, bottom_left_to_top_right.size / 2)
  end

  def collect_diagonal(column, row, col_step, row_step)
    diagonal = []
    col, r = column + col_step, row + row_step

    while col.between?(0, @board.length - 1) && r.between?(0, @board[0].length - 1)
      diagonal << @board[col][r]
      col += col_step
      r += row_step
    end

    diagonal
  end

  def update_player
    @current_player = @current_player == 'Y' ? 'R' : 'Y'
  end
end
