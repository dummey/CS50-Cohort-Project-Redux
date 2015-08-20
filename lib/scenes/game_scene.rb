require 'scene'

require 'game_objects/asteroid'
require 'game_objects/background'
require 'game_objects/player'
require 'game_objects/laser_beam'
require 'game_objects/ufo'
require 'game_objects/game_hud'
require 'game_objects/ui_components/title'

class GameScene < Scene
  attr_accessor :window, :lives, :score, :space
  def initialize(window)
    @window = window
    
    @space = CP::Space.new()
    @space.damping = 0.8

    @lives = $CONFIG[:initialize_lives]
    @score = $CONFIG[:initialize_score]
    @game_duration = 0.0

    @background = Background.new(self, {
       :image => $MEDIA_ROOT + "/Backgrounds/purple.png",
       :music => $MEDIA_ROOT + "/Music/80s-Space-Game-Loop_v001.ogg"
    })

    @ui = GameHUD.new(self)
    @asteroids = []
    @asteroids << Asteroid.new(self)
    @asteroids << Asteroid.new(self)
    @asteroids << Asteroid.new(self)
    @player = Player.new(self)

    @lasers = []

    @ufos = []
    mother = UFO.new(self, :image_path => $CONFIG[:sprite_ufo][0])
    @ufos << mother
    @ufos << mother.spawn_baby
    # @ufos << mother.spawn_baby
    @ufos.each {|ufo|
      @space.add_body(ufo.shape.body)
      @space.add_shape(ufo.shape)
    }

    @space.add_collision_func(:player, :ufo) {|| self.decrease_lives}
    self.create_universe_boundary
    @dialog = CharacterDialog.new(self, :duration => 5000) 
  end
  
  def create_universe_boundary
    edge = CP::Body.new_static()
    up_left = vec2(0, 0)
    up_right = vec2(self.width, 0)
    down_left = vec2(0, self.height)
    down_right = vec2(self.width, self.height)
    boundaries = {
      left_edge: CP::Shape::Segment.new(edge, up_left, down_left, 1),
      right_edge: CP::Shape::Segment.new(edge, up_right, down_right, 1),
      top_edge: CP::Shape::Segment.new(edge, up_left, up_right, 1),
      bottom_edge: CP::Shape::Segment.new(edge, down_left, down_right, 1)
    }
    boundaries.each_value {|value| value.sensor = true}
    boundaries.each {|key, value| value.collision_type = key }
    boundaries.each_value {|value| @space.add_shape(value)} 
    handler = EdgeCollisionHandler.new(@player)
    boundaries.each_key {|key| @space.add_collision_handler(:player_sensor, key, handler)}
  end

  class EdgeCollisionHandler
    def initialize(player)
      @player = player
    end
    
    def begin(a, b)
      @player.display_ghost(b.collision_type, true)
    end

    def separate(a, b)
      @player.display_ghost(b.collision_type, false)
    end
  end

  def decrease_lives
    @lives -= 1
    if @lives == 0
      self.lose
    end
    @player.reset
  end

  def update
    if Gosu::button_down? Gosu::KbRight
      @player.rotate(3)
    end
    if Gosu::button_down? Gosu::KbLeft
      @player.rotate(-3)
    end
    if Gosu::button_down? Gosu::KbUp
      @player.thrust(50)
    end
    
    if Gosu::button_down? Gosu::KbSpace
      laser = Laser_Beam.new(self)
      @player.fire(laser)
      @lasers << laser
    end
    
    @game_duration += self.update_interval
    @score = @game_duration.to_i / 1000

    @background.update
    @ui.update
    @asteroids.each do |asteroid|
      asteroid.update
    end

    @player.update

    @lasers.each(&:update)

    @ufos.each(&:update)

    @space.step(1.0/60.0)

    @dialog.update

    @lose.update if @lose
    
    self
  end

  def draw
    @background.draw
    @ui.draw
    @asteroids.each do |asteroid|
      asteroid.draw
    end
    @player.draw
    @ufos.each(&:draw)
    
    @lasers.each(&:draw)
    
    @dialog.draw

    @lose.draw if @lose

    self
  end

  def button_down(id)
    if id == Gosu::KbA
      self.lose
    end
    if id == Gosu::KbF
      dead_asteroids = []
      baby_asteroids = []
      @asteroids.each do |mother_asteroid|
        new_baby_asteroids = mother_asteroid.die()
        baby_asteroids.push(*new_baby_asteroids)
        dead_asteroids << mother_asteroid
        #remove mother asteroid from @asteroids
      end
      @asteroids = @asteroids - dead_asteroids
      @asteroids.push(*baby_asteroids)
    end
    if id == Gosu::KbG
    end
  end

  def button_up(id)
  
  end

  def lose
    @lose ||= Title.new(self, text: "YOU LOSE FOOL!")
  end

end
