require_relative 'simulation'
require 'java'

java_import 'javax.swing.JPanel'
java_import 'java.awt.Color'

class SimulationPanel < JPanel
  attr_reader :simulation
  attr_accessor :show_changes, :show_location
  def initialize(size = 20)
    @simulation = Simulation.new(size)
    @show_changes = true
    @show_location = true
  end
  def board
    @simulation.board
  end
  def old_board
    @simulation.old_board
  end
  def step
    @simulation.step
  end
  def resize(size)
    @simulation.resize(size)
  end
  def paintComponent(g)
    super(g)
    rect_width = get_size.get_width / board.length
    rect_height = get_size.get_height / board.length
    (0..board.length - 1).each do |i|
      (0..board[i].length - 1).each do |j|
        if board[i][j]
          if old_board[i][j] || !@show_changes
            g.set_color(Color::BLACK)
          else
            g.set_color(Color::GREEN)
          end
          g.fill_rect(j * rect_width, i * rect_height, rect_width, rect_height)
          if @show_location
            g.set_color(Color::WHITE)
            g.draw_string("#{i},#{j}", j * rect_width, i * rect_height + rect_height)
          end
        elsif old_board[i][j] && @show_changes
          g.set_color(Color::RED)
          g.fill_rect(j * rect_width, i * rect_height, rect_width, rect_height)
          if @show_location
            g.set_color(Color::WHITE)
            g.draw_string("#{i},#{j}", j * rect_width, i * rect_height + rect_height)
          end
        elsif @show_location
            g.set_color(Color::BLACK)
          g.draw_string("#{i},#{j}", j * rect_width, i * rect_height + rect_height)
        end
      end
    end
  end
end
