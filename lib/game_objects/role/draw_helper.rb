module DrawHelper
  def draw_centered(x, y)
    self.image.draw_rot(x, y, @z_index, self.body.a.radians_to_gosu, 0.5, 0.5, @scale, @scale)
  end
end