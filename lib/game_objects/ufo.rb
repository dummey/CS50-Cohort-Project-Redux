require 'game_object'
require 'game_objects/ui_components/character_dialog'

class UFO < GameObject
  attr_reader :shape

  def _defaults(params)
    {
      :image_path => $CONFIG[:sprite_ufo].sample,
      :init_x_pos => rand(0...@scene.width),
      :init_y_pos => rand(0...@scene.height),
      :scale => 0.5,
      :mass => 4,
      :moi => 150,
      :spin_rate => Math::PI/20.0,
      :ai_interval => 1000,
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
    @shape.body.apply_force(CP::Vec2.new(x, y), CP::Vec2.new(0.0, 0.0))
  end

  #deals with wrap around logic
  # def accelerate_towards(x, y, magnitude = @max_acceleration / 2)
  #   # horizontal
  #   right_distance = 0
  #   left_distance = 0
  #   if (@x_pos < x)
  #     right_distance = x - @x_pos
  #     left_distance =  @scene.width - x + x_pos
  #   else
  #     right_distance = @scene.width - @x_pos + x
  #     left_distance = @x_pos - x
  #   end

  #   if (right_distance < left_distance)
  #     self.accelerate(magnitude, 0)
  #   else
  #     self.accelerate(-magnitude, 0)
  #   end

  #   #vertical
  #   bottom_distance = 0
  #   top_distance = 0
  #   if (@y_pos < y)
  #     bottom_distance = y - @y_pos
  #     top_distance =  @scene.height - y + y_pos
  #   else
  #     bottom_distance = @scene.height - @y_pos + y
  #     top_distance = @y_pos - y
  #   end

  #   if (bottom_distance < top_distance)
  #     self.accelerate(0, magnitude)
  #   else
  #     self.accelerate(0, -magnitude)
  #   end
  # end

  def _ai
    @time_alive += @scene.update_interval
    if (@time_alive - @last_ai_update > @ai_interval)
      if @follow
        # x_pos = @follow.shape.body.p.x - @shape.body.p.x
        # y_pos = @follow.shape.body.p.y - @shape.body.p.y
        # self.accelerate(x_pos, y_pos)
        # if x_pos.abs < 200
        #   self.accelerate(200 - x_pos.abs * 1000, 0)
        # end

        # if y_pos.abs < 200
        #   self.accelerate(0, 200 - y_pos.abs * 1000)
        # end
      else
        self.accelerate(Gosu::random(-@max_acceleration, @max_acceleration),
                        Gosu::random(-@max_acceleration, @max_acceleration))
      end
      @last_ai_update = @time_alive
    end
  end

  def spawn_baby
    UFO.new(@scene, :scale => @scale / 2, :mase => @mass / 4)
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

    @image.draw_rot(self.body.p.x, self.body.p.y, @z_index, self.body.a.radians_to_gosu, 0.5, 0.5, @scale, @scale)

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
