require 'game_object'
require 'game_objects/role/draw_helper'

class Player < GameObject
  include DrawHelper
  
  def initialize(scene)
    super(scene)
    @image_path = "media/PNG/playerShip3_green.png"
    @body = CP::Body.new(10.0, 150.0)
    @z_index = 1
    @scale = 1
    @shape_boundary = CP::Shape::Circle.new(@body, self.image.width/2, CP::Vec2::ZERO)
    @shape_boundary.sensor = true
    @shape_boundary.collision_type = :player_sensor
    @shape_collide = CP::Shape::Circle.new(@body, self.image.width/4, CP::Vec2::ZERO)
    @shape_collide.collision_type = :player
    @body.p = CP::Vec2.new(@scene.width/2, @scene.height/2)
    @body.a = 0.gosu_to_radians
    scene.space.add_body(@body)
    scene.space.add_shape(@shape_boundary)
    scene.space.add_shape(@shape_collide)
    self.setup_boundary
  end

  def body
    return @body
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
  end

  def reset
    @body.p = CP::Vec2.new(@scene.width/2, @scene.height/2)
    @body.a = 0.gosu_to_radians
    @body.v = CP::Vec2::ZERO
    @body.w = 0
    @body.reset_forces
    #add invulnerability
  end

  def draw
    self.draw_with_boundary
  end

end
