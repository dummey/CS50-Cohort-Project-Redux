require 'game_object'

class Player < GameObject
  def initialize(scene)
    super(scene)
    @image = Gosu::Image.new("media/PNG/playerShip3_green.png")
    @body = CP::Body.new(10.0, 150.0)
    @shape = CP::Shape::Circle.new(@body, @image.width/2, CP::Vec2::ZERO)
    @body.p = CP::Vec2.new(@scene.width/2, @scene.height/2)
    @body.a = 0.gosu_to_radians
    scene.space.add_body(@body)
    scene.space.add_shape(@shape)
    @shape.collision_type = :player
    @ghost = { left_edge: false, right_edge: false, top_edge: false, bottom_edge: false}
  end

  def display_ghost(edge, enabled)
    @ghost[edge] = enabled
  end

  def thrust(scalar)
    @body.apply_impulse(CP::Vec2.for_angle(@body.a) * scalar, CP::Vec2::ZERO)
  end
  
  def rotate(degrees)
    @body.a += degrees.degrees_to_radians
  end

  def update
    #wrap around the field
    @body.p.x = @body.p.x % @scene.width
    @body.p.y = @body.p.y % @scene.height
  end

  def draw
    # (x, y, z, angle, center_x, center_y, scale_x, scale_y)
    # draw main
    @image.draw_rot(@body.p.x, @body.p.y, 1, @body.a.radians_to_gosu)
    
    # draw ghost
    if @ghost[:left_edge]
      @image.draw_rot(@scene.width + @body.p.x, @body.p.y, 1, @body.a.radians_to_gosu)
    end
    if @ghost[:right_edge]
      @image.draw_rot(@body.p.x - @scene.width, @body.p.y, 1, @body.a.radians_to_gosu)
    end
    if @ghost[:top_edge]
      @image.draw_rot(@body.p.x, @scene.height + @body.p.y, 1, @body.a.radians_to_gosu)
    end
    if @ghost[:bottom_edge]
      @image.draw_rot(@body.p.x, @body.p.y - @scene.height, 1, @body.a.radians_to_gosu)
    end
  end

end
