require 'game_object'

class Player < GameObject
  def initialize(scene)
    super(scene)
    @body = CP::Body.new(10.0, 150.0)
    @body.p = CP::Vec2.new(@scene.width/2, @scene.height/2)
    @body.a = 0.gosu_to_radians
    scene.space.add_body(@body)
    @player = Gosu::Image.new("media/PNG/playerShip3_green.png")
  end

  def rotate(degrees)
    @body.a += degrees.degrees_to_radians
  end

  def update
    # constant negative velocity
  end

  def draw
    # (x, y, z, angle, center_x, center_y, scale_x, scale_y)
    @player.draw_rot(@body.p.x, @body.p.y, 1, @body.a.radians_to_gosu)

  end
end
