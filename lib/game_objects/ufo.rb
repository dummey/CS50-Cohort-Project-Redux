require 'game_object'
require 'game_objects/ui_components/character_dialog'
require 'game_objects/role/draw_helper'

class UFO < GameObject
  include DrawHelper

  attr_reader :shape, :image

  def _defaults(params)
    {
      :image_path => $CONFIG[:sprite_ufo].sample,
      :init_x_pos => rand(0...@scene.width),
      :init_y_pos => rand(0...@scene.height),
      :scale => 0.5,
      :mass => 4,
      :moi => 150,
      :spin_rate => Math::PI/20.0,
      :ai_interval => 100,
      :z_index => 5, #$CONIFG[:z_index_ufo]
      :max_velocity => 50.0,
      :max_acceleration => 100.0,
      :num_mini_me => 3,
      :follow => nil
    }.merge(params)
  end

  def initialize(scene, params = {})
    super(scene)
    _defaults(params).each {|k,v| instance_variable_set("@#{k}", v)}

    @image = Gosu::Image.new(@image_path)

    body = CP::Body.new(10.0, 150.0)
    body.p.x = @init_x_pos
    body.p.y = @init_y_pos
    body.v_limit = @max_velocity

    @shape = CP::Shape::Circle.new(body, @image.width / 2 * @scale, CP::Vec2::ZERO)
    @shape.e = 0.5
    @shape.collision_type = :ufo

    @time_alive = 0
    @last_ai_update = -1 * Float::INFINITY
  end

  def body
    @shape.body
  end

  def accelerate(x, y)
    @shape.body.reset_forces
    @shape.body.apply_force(
      CP::Vec2.new(x, y),
      CP::Vec2::ZERO
    )
  end

  def _ai
    @time_alive += @scene.update_interval
    if (@time_alive - @last_ai_update > @ai_interval)
      if @follow
        x_pos = @follow.shape.body.p.x - @shape.body.p.x
        y_pos = @follow.shape.body.p.y - @shape.body.p.y

        self.accelerate(x_pos * 100, y_pos * 100)
      else
        self.accelerate(Gosu::random(-@max_acceleration, @max_acceleration),
                        Gosu::random(-@max_acceleration, @max_acceleration))
      end
      @last_ai_update = @time_alive
    end
  end

  def spawn_baby
    UFO.new(@scene, :scale => @scale / 2,
            :mase => @mass / 4,
            :init_x_pos => self.body.p.x,
            :init_y_pos => self.body.p.y,
            :follow => self,
            :max_velocity => @max_velocity * 10)
  end

  def update
    self._ai

    #Spinnnn!
    @shape.body.a += @spin_rate

    #Wrap around the field
    @shape.body.p.x = @shape.body.p.x % @scene.width
    @shape.body.p.y = @shape.body.p.y % @scene.height

    self
  end

  def draw
    #Draw main


    self.draw_centered(self.body.p.x, self.body.p.y)

    if (self.body.p.y < @image.height / 2)
      @image.draw_rot(self.body.p.x, @scene.height + self.body.p.y, @z_index, self.body.a.radians_to_gosu, 0.5, 0.5, @scale, @scale)
    elsif (self.body.p.y > @scene.height + @image.height / 2)
      @image.draw_rot(self.body.p.x, self.body.p.y - @scene.height, @z_index, self.body.a.radians_to_gosu, 0.5, 0.5, @scale, @scale)
    elsif (self.body.p.x < @image.width / 2)
      @image.draw_rot(@scene.width + self.body.p.x, self.body.p.y, @z_index, self.body.a.radians_to_gosu, 0.5, 0.5, @scale, @scale)
    elsif (self.body.p.x > @scene.width + @image.width / 2)
      @image.draw_rot(self.body.p.x - @scene.width, self.body.p.y, @z_index, self.body.a.radians_to_gosu, 0.5, 0.5, @scale, @scale)
    end

    self
  end
end
