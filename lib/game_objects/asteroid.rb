require 'game_object'
require 'game_objects/role/draw_helper'
require 'game_objects/role/defaultable'
require 'game_objects/role/chipmunk_object'
require 'game_objects/role/destroyable'

class Asteroid < GameObject
  include DrawHelper
  include ChipmunkObject
  include Defaultable
  include Destroyable

  def _defaults
    {
      :image_path => "media/PNG/Meteors/meteorGrey_big1.png",
      :init_x_pos => rand(0...@scene.width),
      :init_y_pos => rand(0...@scene.height),
      :mass => 10,
      :max_velocity => 250.0,
      :max_rotational_velocity => 10,
      :moment_of_inertia => 150,
      :scale => 1,
      :z_index => 1,
      :init_rotate => 0,
      :tier => 1,
      :max_tier => 3,
      :collision_type => :asteroid,
      :collision_sensor => true,
      :bit_plane => 0b11,
    }
  end

  def initialize(scene, params = {})
    super(scene)

    setup_defaults(params)

    @image_path = {
      1 => "media/PNG/Meteors/meteorGrey_big1.png",
      2 => "media/PNG/Meteors/meteorGrey_med1.png",
      3 => "media/PNG/Meteors/meteorGrey_small1.png",
      4 => "media/PNG/Meteors/meteorGrey_tiny1.png",
    }[@tier]

    setup_chipmunk
    setup_boundary

    self.body.velocity_func{ |b, g, d, dt| }

    self.body.v = CP::Vec2.new(rand(-@max_velocity...@max_velocity), rand(-@max_velocity...@max_velocity))
    self.body.w = rand(-@max_rotational_velocity...@max_rotational_velocity)

    scene.space.add_body(self.body)
    scene.space.add_shape(self.shape)
  end

  def update
    #Wrap around the field
    @shape.body.p.x = @shape.body.p.x % @scene.width
    @shape.body.p.y = @shape.body.p.y % @scene.height

    if destroyed?
      update_objects = [Explosion.new(@scene, x_pos: @shape.body.p.x, y_pos: @shape.body.p.y, scale: 0.25 / @tier)]
      
      return update_objects if @tier > @max_tier - 1

      @max_tier.times do 
        update_objects << Asteroid.new(@scene, init_x_pos: body.p.x, init_y_pos: body.p.y, tier: @tier+1)
      end
      update_objects
    else
      self
    end
  end

  def draw
    draw_with_boundary

    self
  end

end