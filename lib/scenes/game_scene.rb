require 'scene'

require 'game_objects/asteroid'
require 'game_objects/background'
require 'game_objects/player'
require 'game_objects/ufo'
require 'game_objects/game_hud'
require 'game_objects/ui_components/title'

class GameScene < Scene
  attr_accessor :window, :lives, :score, :space
  def initialize(window)
    @window = window
    
    @space = CP::Space.new()
    @space.damping = 0.8
    
    @test_player = Player.new(self)
    
    @space.add_collision_handler(:ship, :ship) do |player, test_player|
      self.lose
      true
    end

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
    @ufo = UFO.new(self, :image_path => $CONFIG[:sprite_ufo][0])
    @ufo2 = UFO.new(self, :image_path => $CONFIG[:sprite_ufo][1])
    @ufo3 = UFO.new(self, :image_path => $CONFIG[:sprite_ufo][2])

    @dialog = CharacterDialog.new(self, :duration => 5000) 
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
    
    @game_duration += self.update_interval
    @score = @game_duration.to_i / 1000

    @background.update
    @ui.update
    @asteroids.each do |asteroid|
      asteroid.update
    end

    @player.update
    
    @test_player.update

    @ufo.update
    @ufo2.update
    @ufo3.update

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
    @test_player.draw
    @ufo.draw
    @ufo2.draw
    @ufo3.draw

    @dialog.draw

    @lose.draw if @lose

    self
  end

  def button_down(id)
    if id == Gosu::KbA
      self.lose
    end
    if id == Gosu::KbF
      asteroids_add = []
      @asteroids.each do |asteroid|
        asteroids_add.push(*asteroid.die)
      end
      @asteroids.push(*asteroids_add)
    end
  end

  def button_up(id)
  
  end

  def lose
    @lose ||= Title.new(self, text: "YOU LOSE FOOL!")
  end

end
