require 'game_objects/role/has_game_objects'

class Scene
  include HasGameObjects

  def initialize(window)
    @window = window
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
    update_game_objects
  end

  def draw
    draw_game_objects
  end

  def button_down(id)
    button_down_game_objects(id)
  end

  def button_up(id)
    button_up_game_objects(id)
  end

  # Handles the wrap around world stuff
  def direction_to(a, b)
    delta_x = b.body.p.x - a.body.p.x
    delta_y = b.body.p.y - a.body.p.y
    
    if (delta_x.abs) < width / 2
      # p "x do not wrap"
      delta_x = delta_x
    else 
      # p "x wrap"
      delta_x = -delta_x
      if delta_x > 0
        delta_x -= width / 2
      else
        delta_x += width / 2
      end
    end

    if (delta_y.abs) < width / 2
      # p "y do not wrap"
      delta_y = delta_y
    else
      # p "y wrap"
      delta_y = -delta_y
      if delta_y > 0
        delta_y -= height / 2
      else
        delta_y += height / 2
      end
    end

    # p a.object_id, b.object_id, delta_x, delta_y

    return [delta_x, delta_y]
  end
end
