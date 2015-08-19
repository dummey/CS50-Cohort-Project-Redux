require 'game_object'
require 'pp'

class Player < GameObject
  def initialize(scene)
    super(scene)
    @image = Gosu::Image.new("media/PNG/playerShip3_green.png")
    @body = CP::Body.new(10.0, 150.0)
    @shape_boundary = CP::Shape::Circle.new(@body, @image.width/2, CP::Vec2::ZERO)
    @shape_boundary.sensor = true
    @shape_boundary.collision_type = :player_sensor
    @shape_collide = CP::Shape::Circle.new(@body, @image.width/4, CP::Vec2::ZERO)
    @shape_collide.collision_type = :player
    @body.p = CP::Vec2.new(@scene.width/2, @scene.height/2)
    @body.a = 0.gosu_to_radians
    scene.space.add_body(@body)
    scene.space.add_shape(@shape_boundary)
    scene.space.add_shape(@shape_collide)
    @boundary = { left_edge: false, right_edge: false, top_edge: false, bottom_edge: false}
  end

  def display_ghost(edge, enabled)
    @boundary[edge] = enabled
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

    if @reset
      @body.activate
      @body.p = CP::Vec2.new(@scene.width/2, @scene.height/2)
      @body.a = 0.gosu_to_radians
      @body.v = CP::Vec2::ZERO
      @body.w = 0
      @body.reset_forces

      @reset = false
    end 
  end

  def reset
    @reset = true
  end

  def draw
    # (x, y, z, angle, center_x, center_y, scale_x, scale_y)
    # draw main
    @image.draw_rot(@body.p.x, @body.p.y, 1, @body.a.radians_to_gosu)
    
    # draw ghost
    if @boundary[:left_edge]
      @image.draw_rot(@body.p.x + @scene.width, @body.p.y, 1, @body.a.radians_to_gosu)
    end
    if @boundary[:right_edge]
      @image.draw_rot(@body.p.x - @scene.width, @body.p.y, 1, @body.a.radians_to_gosu)
    end
    if @boundary[:top_edge]
      @image.draw_rot(@body.p.x, @body.p.y + @scene.height, 1, @body.a.radians_to_gosu)
    end
    if @boundary[:bottom_edge]
      @image.draw_rot(@body.p.x, @body.p.y - @scene.height, 1, @body.a.radians_to_gosu)
    end
    if @boundary[:top_edge] && @boundary[:left_edge]
      @image.draw_rot(@body.p.x + @scene.width, @body.p.y + @scene.height, 1, @body.a.radians_to_gosu)
    end
    if @boundary[:top_edge] && @boundary[:right_edge]
      @image.draw_rot(@body.p.x - @scene.width, @body.p.y + @scene.height, 1, @body.a.radians_to_gosu)
    end
    if @boundary[:bottom_edge] && @boundary[:right_edge]
      @image.draw_rot(@body.p.x - @scene.width, @body.p.y - @scene.height, 1, @body.a.radians_to_gosu)
    end
    if @boundary[:bottom_edge] && @boundary[:left_edge]
      @image.draw_rot(@body.p.x + @scene.width, @body.p.y - @scene.height, 1, @body.a.radians_to_gosu)
    end
  end

end
