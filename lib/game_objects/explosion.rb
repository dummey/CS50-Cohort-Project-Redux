require 'game_object'
require 'game_objects/role/defaultable'

class Explosion < GameObject
  include Defaultable
  def _defaults
    {
      :pulse => 1,
      :duration => rand(500...1000),
      :image_path => "#{$MEDIA_ROOT}/PNG/Flash/flash00.png",
      :x_pos => rand(0...@scene.width),
      :y_pos => rand(0...@scene.height),
      :rotation => 0,
      :direction => rand(-10...10),
      :color => Gosu::Color.argb(0, rand(200..255), rand(200..255), rand(200..255)),
      :scale => 0.25,
      :sound_effect => "#{$MEDIA_ROOT}/Sound Effects/" + "Depth Charge 2-SoundBible.com-338644910.ogg"
    }
  end

  def initialize(scene, params = {})
    super(scene)
    setup_defaults(params)

    @image = Gosu::Image.new(@image_path)
    @time_alive = 0

    @sound_effect = Gosu::Sample.new(@sound_effect)
    @sound_effect.play
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

    alpha = (255 * _pulse_cycle).to_i
    @color = Gosu::Color.argb(alpha, @color.red, @color.green, @color.blue)

    self
  end

  def draw
    @image.draw_rot(@x_pos, @y_pos, 1, @rotation, 0.5, 0.5, @scale, @scale, @color)

    self
  end
end
