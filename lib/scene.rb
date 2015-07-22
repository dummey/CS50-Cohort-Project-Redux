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

  def update
    @game_objects.map! {|o| o.update}
    @game_objects.flatten!
    @game_objects.compact!
  end

  def draw
    @game_objects.each {|o| o.draw}
  end

  def button_down(id)
    @game_objects.each {|o| o.button_down(id)}
  end

  def button_up(id)
    @game_objects.each {|o| o.button_up(id)}
  end
end
