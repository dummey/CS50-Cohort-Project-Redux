require 'game_object'
require 'game_objects/ui_components/character_dialog'

class UFO < GameObject
  attr_reader :x_pos, :y_pos, :image, :scale

  def _defaults(params)
    {
      :image_path => $CONFIG[:sprite_ufo].sample,
      :x_pos => rand(0...@scene.width),
      :y_pos => rand(0...@scene.height),
      :x_vel => 0.0,
      :y_vel => 0.0,
      :x_acc => 0.0,
      :y_acc => 0.0,
      :dampening => 0.5,
      # :level => 1,
      :scale => 0.5,
      :spin_rate => 100,
      :ai_interval => 1000,
      :angle => 0,
      :z_index => 5, #$CONIFG[:z_index_ufo]
      :max_velocity => 50.0,
      :max_acceleration => 50.0,
      :num_mini_me => 3,
    }.merge(params)
  end

  def initialize(scene, params = {})
    super(scene)
    _defaults(params).each {|k,v| instance_variable_set("@#{k}", v)}

    @image = Gosu::Image.new(@image_path)

    @time_alive = 0
    @last_ai_update = -1 * Float::INFINITY

    @mini_mes = []
    @num_mini_me.times {
      @mini_mes.push(UFO.new(@scene,
                             :scale => @scale / 2,
                             :num_mini_me => 0,
                             :ai_interval => Float::INFINITY,
                             :max_velocity => 25,
                             :max_acceleration => 25,
                             :image_path => @image_path,
                             ))
    }

    @dialog = CharacterDialog.new(@scene)
  end

  def accelerate(x, y)
    @x_acc += x
    @x_acc = [-1 * @max_acceleration, @x_acc, @max_acceleration].sort[1]

    @y_acc += y
    @y_acc = [-1 * @max_acceleration, @y_acc, @max_acceleration].sort[1]
  end

  #deals with wrap around logic
  def accelerate_towards(x, y, magnitude = @max_acceleration / 2)
    # horizontal
    right_distance = 0
    left_distance = 0
    if (@x_pos < x)
      right_distance = x - @x_pos
      left_distance =  @scene.width - x + x_pos
    else
      right_distance = @scene.width - @x_pos + x
      left_distance = @x_pos - x
    end

    if (right_distance < left_distance)
      self.accelerate(magnitude, 0)
    else
      self.accelerate(-magnitude, 0)
    end

    #vertical
    bottom_distance = 0
    top_distance = 0
    if (@y_pos < y)
      bottom_distance = y - @y_pos
      top_distance =  @scene.height - y + y_pos
    else
      bottom_distance = @scene.height - @y_pos + y
      top_distance = @y_pos - y
    end

    if (bottom_distance < top_distance)
      self.accelerate(0, magnitude)
    else
      self.accelerate(0, -magnitude)
    end
  end

  def _ai
    self.accelerate(Gosu::random(-@max_acceleration, @max_acceleration),
                    Gosu::random(-@max_acceleration, @max_acceleration))
  end

  def update
    #Figure out when to call the AI code
    @time_alive += @scene.update_interval
    if (@time_alive - @last_ai_update > @ai_interval)
      self._ai
      @last_ai_update = @time_alive
    end

    #Spinnnn!
    @angle += @spin_rate * @scene.update_interval / 1000.0

    #Dampening
    @x_vel *= 1 - @dampening * @scene.update_interval / 1000.0
    @y_vel *= 1 - @dampening * @scene.update_interval / 1000.0

    #Apply acceleration to velocity
    @x_vel += @x_acc * @scene.update_interval / 1000.0
    @y_vel += @y_acc * @scene.update_interval / 1000.0

    #Apply velocity to position
    @x_pos += @x_vel * @scene.update_interval / 1000.0
    @y_pos += @y_vel * @scene.update_interval / 1000.0

    #Wrap around the field
    @x_pos = @x_pos % @scene.width
    @y_pos = @y_pos % @scene.height

    #Update children
    @mini_mes.map! {|o|
      o.accelerate_towards(@x_pos, @y_pos, 20)
      @mini_mes.each {|oo|
        next if oo == o
        next unless Gosu::distance(o.x_pos, o.y_pos, oo.x_pos, oo.y_pos) < o.image.width * o.scale * 2
        o.accelerate_towards(oo.x_pos, oo.y_pos, -@max_acceleration)
      }
      o.update
    }
    @mini_mes.flatten!
    @mini_mes.compact!

    if @time_alive > 2000.0 && @dialog.duration <= 0.0
      @dialog.show_for(10000)
    end

    self
  end

  def draw
    #Draw main
    @image.draw_rot(@x_pos, @y_pos, @z_index, @angle, 0.5, 0.5, @scale, @scale)

    #Draw wrap-around
    if (@x_pos < @image.width / 2)
      @image.draw_rot(@scene.width + @x_pos, @y_pos, @z_index, @angle, 0.5, 0.5, @scale, @scale)
    elsif (@x_pos > @scene.width + @image.width / 2)
      @image.draw_rot(@x_pos - @scene.width, @y_pos, @z_index, @angle, 0.5, 0.5, @scale, @scale)
    elsif (@y_pos < @image.height / 2)
      @image.draw_rot(@x_pos, @scene.height + @y_pos, @z_index, @angle, 0.5, 0.5, @scale, @scale)
    elsif (@y_pos > @scene.height + @image.height / 2)
      @image.draw_rot(@x_pos, @y_pos - @scene.height, @z_index, @angle, 0.5, 0.5, @scale, @scale)
    end

    #Draw children
    @mini_mes.each {|o| o.draw}

    #Draw dialog
    @dialog.draw

    self
  end
end
