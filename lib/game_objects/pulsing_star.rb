require 'game_object'

class PulsingStar < GameObject
  def initialize(scene, params = {})
    super(scene)

    @p = {
      :pulse => rand(1...3),
      :duration => rand(2000...8000),
      :image => $CONFIG[:sprite_star].sample,
      :x_pos => rand(0...@scene.width),
      :y_pos => rand(0...@scene.height),
      :rotation => rand(0..360),
      :direction => rand(-10...10),
      :color => Gosu::Color.argb(0, rand(200..255), rand(200..255), rand(200..255))
    }.merge(params)

    @image = Gosu::Image.new($CONFIG[:sprite_star].sample)

    @x_pos = @p[:x_pos]
    @y_pos = @p[:y_pos]
    @color = @p[:color]

    @time_alive = 0
  end

  def _pulse_cycle
    normalized_time_alive = (@time_alive / @p[:duration]) * 2.0 * Math::PI * @p[:pulse]
    (Math.cos(normalized_time_alive) * -1 + 1.0) / 2.0
  end

  def update
    @time_alive += @scene.update_interval
    if (@time_alive.to_i > @p[:duration])
      @demolish = true
    end

    @p[:rotation] += @p[:direction] * @scene.update_interval / 1000

    alpha = (100 * _pulse_cycle).to_i
    @color = Gosu::Color.argb(alpha, @color.red, @color.green, @color.blue)
  end

  def draw
    @image.draw_rot(@x_pos, @y_pos, 1, @p[:rotation], 0.5, 0.5, 1, 1, @color)
  end
end