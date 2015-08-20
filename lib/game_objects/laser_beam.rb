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
      :scale => 0.25,
      :spin_rate => Math::PI/5.0,
      :z_index => 1,
      :duration => 375,
    }
  end
  
  def initialize(scene, params = {})
    super(scene)
    setup_defaults(params)
    @body = CP::Body.new(1.0, 150.0)
    #overriding velocity function to be constant (no damping)
    @body.velocity_func{ |b, g, d, dt| }
    @shape = CP::Shape::Circle.new(@body, self.image.width/2 * @scale, CP::Vec2::ZERO)
    @shape.sensor = true
    @shape.collision_type = :laser
    scene.space.add_body(@body)
    scene.space.add_shape(@shape)
    self.setup_boundary
    @time_alive = 0
    @timed_out = false
  end
  
  def body
    return @body
  end
  
  def draw
    self.draw_with_boundary
  end
  
  def update
    #spin
    @shape.body.a += @spin_rate
    
    #wrap around the field
    @body.p.x = @body.p.x % @scene.width
    @body.p.y = @body.p.y % @scene.height
    
    @time_alive += @scene.update_interval
    @timed_out = (@time_alive.to_i > @duration)
  end
  
  def fire(position, velocity)
    @body.p = position
    @body.v = velocity
    @body.activate    
  end
  
  def reached_range
    return @timed_out
  end
  
  def remove_from_game
    @scene.space.remove_body(@body)
    @scene.space.remove_shape(@shape)
  end
end