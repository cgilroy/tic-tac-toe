require_relative 'tic_tac_toe'
require 'byebug'
class TicTacToeNode
  attr_accessor :board, :next_mover_mark, :prev_move_pos
  def initialize(board, next_mover_mark, prev_move_pos = nil)
    @board = board
    @next_mover_mark = next_mover_mark
    @prev_move_pos = prev_move_pos
  end

  def losing_node?(evaluator)
    if board.over?
      return board.won? && board.winner != evaluator
    elsif next_mover_mark == evaluator
      return children.all? { |node| node.losing_node?(evaluator) }
    else
      return children.any? { |node| node.losing_node?(evaluator) }
    end
  end

  def winning_node?(evaluator)
    # debugger
    if board.over?
      board.winner == evaluator
    elsif next_mover_mark == evaluator
      children.any? { |node| node.winning_node?(evaluator) }
    else
      children.all? { |node| node.winning_node?(evaluator) }
    end
  end

  # This method generates an array of all moves that can be made after
  # the current move.
  def children
    children = []
    empty_tiles = find_empty_tiles
    empty_tiles.each do |pos|
      new_board = @board.dup
      new_board[pos] = @next_mover_mark
      new_mark = @next_mover_mark == :x ? :o : :x
      children << TicTacToeNode.new(new_board,new_mark,pos)
    end
    children
  end

  def find_empty_tiles
    # debugger
    empty_tiles = []
    @board.rows.each_with_index do |row,row_idx|
      row.each_with_index do |col,col_idx|
        empty_tiles << [row_idx,col_idx] if @board.empty?([row_idx,col_idx])
      end
    end
    empty_tiles
  end
end
