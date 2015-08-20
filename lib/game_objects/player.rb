require 'game_object'
require 'game_objects/role/draw_helper'
require 'game_objects/role/defaultable'
require 'game_objects/role/chipmunk_object'

class Player < GameObject
  include DrawHelper
  include ChipmunkObject
  include Defaultable
  def _defaults
    {
      :image_path => "media/PNG/playerShip3_green.png",
      :init_x_pos => @scene.width/2,
      :init_y_pos => @scene.height/2,
      :mass => 10,
      :max_velocity => 500.0,
      :moment_of_inertia => 150,
      :scale => 1,
      :z_index => 1,
      :collision_type => "player_sensor".to_sym,
      :collision_sensor => true,
      :init_rotate => 0
    }
  end
  
  
  def initialize(scene, params = {})
    super(scene)
    setup_defaults(params)
    setup_chipmunk


    @shape_collide = CP::Shape::Circle.new(self.body, self.image.width/4, CP::Vec2::ZERO)
    @shape_collide.collision_type = :player
    scene.space.add_body(self.body)
    scene.space.add_shape(@shape)
    scene.space.add_shape(@shape_collide)
    self.setup_boundary
  end


  def thrust(scalar)
    self.body.apply_impulse(CP::Vec2.for_angle(self.body.a) * scalar, CP::Vec2::ZERO)
  end
  
  def rotate(degrees)
    self.body.a += degrees.degrees_to_radians
  end
  
  def fire(laser)
    laser.fire(self.body.p + (CP::Vec2.for_angle(self.body.a) * image.width / 4), CP::Vec2.for_angle(self.body.a) * 2 * @max_velocity)
  end

  def update
    #wrap around the field
    self.body.p.x = self.body.p.x % @scene.width
    self.body.p.y = self.body.p.y % @scene.height
  end

  def reset
    self.body.p = CP::Vec2.new(@scene.width/2, @scene.height/2)
    self.body.a = 0.gosu_to_radians
    self.body.v = CP::Vec2::ZERO
    self.body.w = 0
    self.body.reset_forces
    #add invulnerability
  end

  def draw
    self.draw_with_boundary
  end

end
