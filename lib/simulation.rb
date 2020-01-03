class Simulation
  attr_accessor :board, :old_board
  def initialize(size = 100)
    @board = []
    @old_board = []
    resize(size)
  end
  def step
    temp_board = Marshal.load(Marshal.dump(@board))
    (0..@board.length - 1).each do |i|
      (0..@board[i].length - 1).each do |j|
        n = neighbors(i, j)
        @old_board[i][j] = @board[i][j]
        if @board[i][j]
          if n > 3 || n < 2
            temp_board[i][j] = false
            puts "#{i}, #{j} Died; #{n} neighbors"
          end
        else
          if n == 3
            temp_board[i][j] = true
            puts "#{i}, #{j} Born; #{n} neighbors"
          end
        end
      end
    end
    @board = Marshal.load(Marshal.dump(temp_board))
    self
  end
  def resize(size)
    if size > @board.length
      additions = size - @board.length
      (0..@board.length - 1).each do |i|
        (0..additions - 1).each do |j|
          @board[i] << false
          @old_board[i] << false
        end
      end
      (0..additions - 1).each do |i|
        @board << Array.new(size, false)
        @old_board << Array.new(size, false)
      end
    elsif size < @board.length
      removals = @board.length - size
      (0..removals - 1).each do |i|
        @board.delete_at(@board.length - 1)
        @old_board.delete_at(@old_board.length - 1)
      end
      (0..@board.length - 1).each do |i|
        (0..removals - 1).each do |j|
          @board[i].delete_at(@board.length - 1)
          @old_board[i].delete_at(@old_board.length - 1)
        end
      end
    end
    self
  end
  
  private
  
  def neighbors(row, col)
    total = nil
    unless row < 0 || row >= @board.length || col < 0 || col >= @board.length
      total = 0
      hstart = row == 0 ? row : row - 1
      hend = row == @board.length - 1 ? row : row + 1
      vstart = col == 0 ? col : col - 1
      vend = col == @board.length - 1 ? col : col + 1
      (hstart..hend).each do |i|
        (vstart..vend).each do |j|
          unless i == row && j == col
            total += 1 if
              @board[i][j]
          end
        end
      end
    end
    total
  end
end
