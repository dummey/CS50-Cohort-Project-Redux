module DrawHelper

  def image
    abort "@image_path required" unless @image_path
    @image ||= Gosu::Image.new(@image_path)

    @image
  end
  
  def setup_boundary
    @boundary = { left_edge: false, right_edge: false, top_edge: false, bottom_edge: false}
  end

  def draw_centered(x, y)
    self.image.draw_rot(x, y, @z_index, self.body.a.radians_to_gosu, 0.5, 0.5, @scale, @scale)
  end
  
  def display_ghost(edge, enabled)
    @boundary[edge] = enabled
  end
  
  def draw_with_boundary
    # (x, y, z, angle, center_x, center_y, scale_x, scale_y)
    self.draw_centered(self.body.p.x, self.body.p.y)
    
    if @boundary[:left_edge]
      self.draw_centered(self.body.p.x + @scene.width, self.body.p.y)
    end
    if @boundary[:right_edge]
      self.draw_centered(self.body.p.x - @scene.width, self.body.p.y)
    end
    if @boundary[:top_edge]
      self.draw_centered(self.body.p.x, self.body.p.y + @scene.height)
    end
    if @boundary[:bottom_edge]
      self.draw_centered(self.body.p.x, self.body.p.y - @scene.height)
    end
    if @boundary[:top_edge] && @boundary[:left_edge]
      self.draw_centered(self.body.p.x + @scene.width, self.body.p.y + @scene.height)
    end
    if @boundary[:top_edge] && @boundary[:right_edge]
      self.draw_centered(self.body.p.x - @scene.width, self.body.p.y + @scene.height)
    end
    if @boundary[:bottom_edge] && @boundary[:right_edge]
      self.draw_centered(self.body.p.x - @scene.width, self.body.p.y - @scene.height)
    end
    if @boundary[:bottom_edge] && @boundary[:left_edge]
      self.draw_centered(self.body.p.x + @scene.width, self.body.p.y - @scene.height)
    end
  end
  
end