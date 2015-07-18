require 'game_object'

class Score < GameObject
  attr_accessor :score

  def _defaults(params)
    {
      :sprite_score => $CONFIG[:sprite_score],
      :score_images => nil,
      :score => 0,
      :x_pos => 10,
      :y_pos => 50,
      :spacing => 20,
      :z_index => 10,
      :num_digits => 8,
    }.merge(params)
  end

  def initialize(scene, params = {})
    super(scene)
    _defaults(params).each {|k,v| instance_variable_set("@#{k}", v)}

    @score_images = @sprite_score.map{|p| Gosu::Image.new(p)}
  end

  def update

  end

  def draw
    score = "%0#{@num_digits}d" % @score
    i = 0
    score.each_char {|c| 
      @score_images[c.to_i].draw(@x_pos + i * @spacing, @y_pos, @z_index)
      i += 1
    }
  end
end