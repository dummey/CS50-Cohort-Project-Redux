require 'game_object'
require 'game_objects/role/draw_helper'
require 'game_objects/role/defaultable'
require 'game_objects/role/chipmunk_object'
require 'game_objects/explosion'

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
      :init_rotate => 0,
      :bit_plane => 128,
      :jump_sound_effect => "#{$MEDIA_ROOT}/Sound Effects/digital-sfx-set/" + "phaseJump2.ogg"
    }
  end
  
  
  def initialize(scene, params = {})
    super(scene)
    setup_defaults(params)
    setup_chipmunk


    @shape_collide = CP::Shape::Circle.new(self.body, self.image.width/4, CP::Vec2::ZERO)
    @shape_collide.collision_type = :player
    @shape_collide.object = self
    @shape_collide.layers = 0b01
    scene.space.add_body(self.body)
    scene.space.add_shape(@shape)
    scene.space.add_shape(@shape_collide)
    self.setup_boundary

    @jump_sound_effect = Gosu::Sample.new(@jump_sound_effect)
  end


  def thrust(scalar)
    self.body.apply_impulse(CP::Vec2.for_angle(self.body.a) * scalar, CP::Vec2::ZERO)
  end

  def jump
    xrand = Random.new
    yrand = Random.new
    self.body.p.x = xrand.rand(@scene.width)
    self.body.p.y = yrand.rand(@scene.height)
    self.body.v = CP::Vec2::ZERO

    @jump_sound_effect.play
  end
  
  def rotate(degrees)
    self.body.a += degrees.degrees_to_radians
  end
  
  def fire(laser)
    laser.fire(self.body.p + (CP::Vec2.for_angle(self.body.a) * image.width / 4), (CP::Vec2.for_angle(self.body.a) * 1.5 * @max_velocity) + self.body.v)
  end

  def destroy(space)
    @destroyed = true
  end

  def destroyed?
    @destroyed
  end

  def update
    update_objects = [self]
    
    #wrap around the field
    self.body.p.x = self.body.p.x % @scene.width
    self.body.p.y = self.body.p.y % @scene.height

    if destroyed? 
      explosion = Explosion.new(@scene, x_pos: @shape.body.p.x, y_pos: @shape.body.p.y, scale: 0.25)
      update_objects << explosion
      @scene.decrease_lives
    end

    if @reset
      self.body.p = CP::Vec2.new(@scene.width/2, @scene.height/2)
      self.body.a = 0.gosu_to_radians
      self.body.v = CP::Vec2::ZERO
      self.body.w = 0
      self.body.reset_forces
      @reset = false
      @destroyed = false 
    end

    update_objects
  end

  def reset
    @reset = true
  end

  def draw
    self.draw_with_boundary

    self
  end

end
