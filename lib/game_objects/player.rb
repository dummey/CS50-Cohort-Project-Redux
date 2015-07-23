require 'game_object'

class Player < GameObject
  def initialize(scene)
    super(scene)
    @body = CP::Body.new(10.0, 150.0)
    @body.p = CP::Vec2.new(@scene.width/2, @scene.height/2)
    @body.a = 0.gosu_to_radians
    scene.space.add_body(@body)
    @image = Gosu::Image.new("media/PNG/playerShip3_green.png")
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
    
    # draw wrap around
    if (@body.p.x < @image.width / 2)
      @image.draw_rot(@scene.width + @body.p.x, @body.p.y, 1, @body.a.radians_to_gosu)
    elsif (@body.p.x > @scene.width + @image.width / 2)
      @image.draw_rot(@body.p.x - @scene.width, @body.p.y, 1, @body.a.radians_to_gosu)
    elsif (@body.p.y < @image.height / 2)
      @image.draw_rot(@body.p.x, @scene.height + @body.p.y, 1, @body.a.radians_to_gosu)
    elsif (@body.p.y > @scene.height + @image.height / 2)
      @image.draw_rot(@body.p.x, @body.p.y - @scene.height, 1, @body.a.radians_to_gosu)
    end

  end
end
