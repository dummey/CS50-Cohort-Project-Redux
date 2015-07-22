class GameObject
  attr_accessor :demolish

  def initialize(scene)
    @scene = scene
  end

  def _centered
    return [0.5, 0.5, @scale, @scale]
  end

  def _image_pos_centered(x_off = 0, y_off = 0)
    return [@x_pos + x_off, @y_pos + y_off, @z_index, @angle, *self._centered]
  end

  def _text_pos_centered(x_off = 0, y_off = 0)
    return [@x_pos + x_off, @y_pos + y_off, @z_index, *self._centered]
  end

  def button_down(id)

  end

  def button_up(id)

  end
end