require_relative 'simulation_panel'
require 'java'

java_import 'javax.swing.JFrame'
java_import 'javax.swing.JButton'
java_import 'javax.swing.JTextField'
java_import 'javax.swing.JSlider'
java_import 'javax.swing.JCheckBox'
java_import 'java.awt.BorderLayout'
java_import 'java.awt.GridBagLayout'
java_import 'java.awt.GridLayout'
java_import 'java.awt.GridBagConstraints'
java_import 'java.awt.Dimension'
java_import 'java.awt.event.MouseEvent'

class Interface < JFrame
  def initialize
    super('conway\'s game of life')
    
    @running = false
    
    set_default_close_operation(EXIT_ON_CLOSE)
    
    set_layout(BorderLayout.new)
    
    add(generate_screen, BorderLayout::NORTH)
    add(generate_control_panel, BorderLayout::SOUTH)
    
    pack
    set_visible(true)
  end
  def generate_screen
    @panel = SimulationPanel.new
    @panel.set_preferred_size(Dimension.new(800, 800))
    @panel.add_mouse_listener do |e|
      if e.get_id == MouseEvent::MOUSE_CLICKED
        row = e.get_y / (@panel.get_size.get_width / @panel.board.length)
        col = e.get_x / (@panel.get_size.get_height / @panel.board.length)
        row = row.to_i
        col = col.to_i
        @panel.board[row][col] = !@panel.board[row.to_i][col.to_i]
        @panel.repaint
      end
    end
    
    @panel
  end
  def generate_control_panel
    panel = JPanel.new
    panel.set_layout(BorderLayout.new)
    
    panel.add(generate_control_left_panel, BorderLayout::WEST)
    panel.add(generate_control_right_panel, BorderLayout::EAST)
    
    panel
  end
  def generate_control_left_panel
    panel = JPanel.new
    panel.set_layout(GridBagLayout.new)
    
    constraints = GridBagConstraints.new
    constraints.fill = GridBagConstraints::HORIZONTAL
    constraints.weightx = 1
    constraints.weighty = 1
    
    constraints.gridx = 0
    constraints.gridy = 0
    @size = JTextField.new(@panel.board.length.to_s)
    panel.add(@size, constraints)
    
    constraints.gridy += 1
    component = JButton.new('Resize')
    component.add_action_listener do |e|
      @panel.simulation.resize(@size.get_text.to_i)
      @panel.repaint
    end
    panel.add(component, constraints)
    
    constraints.gridy = 0
    constraints.gridx += 1
    @slider = JSlider.new(JSlider::HORIZONTAL, 1, 1000, 1)
    panel.add(@slider, constraints)
    
    constraints.gridy += 1
    component = JButton.new('Run')
    component.add_action_listener do |e|
      @running = !@running
      if @running
        Thread.new { run }
      end
    end
    panel.add(component, constraints)
    
    constraints.gridx += 1
    component = JButton.new('Step')
    component.add_action_listener do |e|
      @panel.step
      @panel.repaint
    end
    panel.add(component, constraints)
    
    panel
  end
  def generate_control_right_panel
    panel = JPanel.new
    
    panel.set_layout(GridLayout.new(0, 1))
    
    component = JCheckBox.new('Show Changes')
    component.set_selected(true)
    component.add_action_listener do |e|
      @panel.show_changes = !@panel.show_changes
      @panel.repaint
    end
    panel.add(component)
    
    component = JCheckBox.new('Show location')
    component.set_selected(true)
    component.add_action_listener do |e|
      @panel.show_location = !@panel.show_location
      @panel.repaint
    end
    panel.add(component)
    
    panel
  end
  
  private
  
  def run
    while @running
      unless @slider.get_value == 0
        @panel.step
        @panel.repaint
        sleep((1001 - @slider.get_value).to_f / 100)
      end
    end
  end
end
