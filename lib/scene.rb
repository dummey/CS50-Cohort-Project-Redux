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

  def mouse_x
    @window.mouse_x
  end

  def mouse_y
    @window.mouse_y
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

  # Handles the wrap around world stuff
  def direction_to(a, b)
    delta_x = a.body.p.x - b.body.p.x
    delta_y = a.body.p.y - b.body.p.y
    
    if (delta_x.abs) > width / 2
      delta_x = delta_x
    else 
      delta_x = -delta_x
    end

    if (delta_y.abs) > width / 2
      delta_y = delta_y
    else
      delta_y = -delta_y
    end

    return [delta_x, delta_y]
  end
end
