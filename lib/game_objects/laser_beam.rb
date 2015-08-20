require 'game_object'
require 'game_objects/role/draw_helper'

class Laser_Beam < GameObject
  include DrawHelper
  
  include Defaultable
  def _defaults
    {
      :image_path => "media/PNG/Lasers/laserRed09.png",
      :init_x_pos => @scene.width/2,
      :init_y_pos => @scene.height/2,
      :mass => 10,
      :max_velocity => 500.0,
      :moment_of_inertia => 150,
      :scale => 0.5,
      :z_index => 1,
    }
  end
  
  
  def initialize(scene, params = {})
    super(scene)
    setup_defaults(params)
    #haven't updated body numbers
    @body = CP::Body.new(10.0, 150.0)
    #double check shape numbers
    @shape = CP::Shape::Circle.new(@body, self.image.width/2, CP::Vec2::ZERO)
    @shape.sensor = true
    @shape.collision_type = :laser
    #I don't know if i need this at all
    #@body.p = CP::Vec2.new(@scene.width/2, @scene.height/2)
    #@body.a = 0.gosu_to_radians
    scene.space.add_body(@body)
    scene.space.add_shape(@shape)
    self.setup_boundary
  end
  
  def body
    return @body
  end
  
  def draw
    self.draw_with_boundary
  end
  
  def update
    #wrap around the field
    @body.p.x = @body.p.x % @scene.width
    @body.p.y = @body.p.y % @scene.height
  end
  
  def fire(position, velocity)
    @body.p = position
    @body.v = velocity
    @body.activate    
  end
  
end