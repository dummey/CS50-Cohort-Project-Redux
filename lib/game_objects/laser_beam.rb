require 'game_object'
require 'game_objects/role/draw_helper'
require 'game_objects/role/chipmunk_object'

class Laser_Beam < GameObject
  include DrawHelper
  include ChipmunkObject
  include Defaultable
  def _defaults
    {
      :image_path => "media/PNG/Lasers/laserRed09.png",
      :init_x_pos => @scene.width/2,
      :init_y_pos => @scene.height/2,
      :mass => 1,
      :max_velocity => 500.0,
      :moment_of_inertia => 150,
      :scale => 0.25,
      :spin_rate => Math::PI/5.0,
      :z_index => 1,
      :duration => 375,
      :collision_type => "laser".to_sym,
      :collision_sensor => true,
    }
  end
  
  def initialize(scene, params = {})
    super(scene)
    setup_defaults(params)
    setup_chipmunk
    #overriding velocity function to be constant (no damping)
    self.body.velocity_func{ |b, g, d, dt| }
    scene.space.add_body(self.body)
    scene.space.add_shape(@shape)
    self.setup_boundary
    @time_alive = 0
    @timed_out = false
  end

  def draw
    self.draw_with_boundary
  end
  
  def update
    #spin
    @shape.body.a += @spin_rate
    
    #wrap around the field
    self.body.p.x = self.body.p.x % @scene.width
    self.body.p.y = self.body.p.y % @scene.height
    
    @time_alive += @scene.update_interval
    @timed_out = (@time_alive.to_i > @duration)
  end
  
  def fire(position, velocity)
    self.body.p = position
    self.body.v = velocity
    self.body.activate    
  end
  
  def hit_target
    @hit_target = true
  end
  
  def reached_range?
    return @timed_out || @hit_target
  end
  
  def remove_from_game
    @scene.space.add_post_step_callback(self.object_id.to_s.to_sym) do |space, key|
      @scene.space.remove_shape(self.shape)
      @scene.space.remove_body(self.body)
    end
  end
end