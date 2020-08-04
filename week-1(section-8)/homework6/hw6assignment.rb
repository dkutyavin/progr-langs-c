# University of Washington, Programming Languages, Homework 6, hw6runner.rb

# This is the only file you turn in, so do not modify the other files as
# part of your solution.

class MyPiece < Piece
  # The constant All_My_Pieces should be declared here
  All_My_Pieces = All_Pieces + 
                  [rotations([[0, 0], [1, 0], [0, 1], [1, 1], [2, 1]]), # axe
                  [[[0, 0], [-1, 0], [1, 0], [2, 0], [3, 0]]], # extra long (we need only 2)
                  [[[0, 0], [0, -1], [0, 1], [0, 2], [0, 3]]],
                  rotations([[0, 0], [1, 0], [0, -1]])] # little L
  # your enhancements here

  def self.next_piece (board)
    MyPiece.new(All_My_Pieces.sample, board)
  end

end

class MyBoard < Board
  # your enhancements here
  def initialize (game)
    super
    @current_block = MyPiece.next_piece(self)
  end

  def next_piece
    @current_block = MyPiece.next_piece(self)
    @current_pos = nil
  end

  def rotate_180
    if !game_over? and @game.is_running?
      @current_block.move(0, 0, 2)
    end
    draw
  end
end

class MyTetris < Tetris
  # your enhancements here
  # creates the window and starts the game

  def set_board
    @canvas = TetrisCanvas.new
    @board = MyBoard.new(self)
    @canvas.place(@board.block_size * @board.num_rows + 3,
                  @board.block_size * @board.num_columns + 6, 24, 80)
    @board.draw
  end

  def key_bindings  
    super
    @root.bind("u", proc {@board.rotate_180})
  end
end

