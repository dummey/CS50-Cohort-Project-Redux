class Scene
  attr_accessor :updatable, :drawable

  def initialize(window)
    @window = window
    @game_objects = []
  end

  def width
    @window.width
  end

  def height
    @window.height
  end

  def update_interval
    @window.update_interval
  end

  def _cleanup 
    @game_objects.delete_if {|o| o.demolish?}
  end

  def update
    _cleanup()
    
    @game_objects.each {|o| o.update}
  end

  def draw
    @game_objects.each {|o| o.draw}
  end

  def button_down(id)

  end

  def button_up(id)

  end
end
