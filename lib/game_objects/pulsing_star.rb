require 'game_object'

class PulsingStar < GameObject
  def _defaults(params)
    {
      :pulse => rand(1...3),
      :duration => rand(2000...8000),
      :image_path => $CONFIG[:sprite_star].sample,
      :x_pos => rand(0...@scene.width),
      :y_pos => rand(0...@scene.height),
      :rotation => rand(0..360),
      :direction => rand(-10...10),
      :color => Gosu::Color.argb(0, rand(200..255), rand(200..255), rand(200..255))
    }.merge(params)
  end

  def initialize(scene, params = {})
    super(scene)
    _defaults(params).each {|k,v| instance_variable_set("@#{k}", v)}

    @image = Gosu::Image.new(@image_path)
    @time_alive = 0
  end

  def _pulse_cycle
    normalized_time_alive = (@time_alive / @duration) * 2.0 * Math::PI * @pulse
    (Math.cos(normalized_time_alive) * -1 + 1.0) / 2.0
  end

  def update
    @time_alive += @scene.update_interval
    if (@time_alive.to_i > @duration)
      return nil
    end

    @rotation += @direction * @scene.update_interval / 1000

    alpha = (100 * _pulse_cycle).to_i
    @color = Gosu::Color.argb(alpha, @color.red, @color.green, @color.blue)

    self
  end

  def draw
    @image.draw_rot(@x_pos, @y_pos, 1, @rotation, 0.5, 0.5, 1, 1, @color)

    self
  end
end
