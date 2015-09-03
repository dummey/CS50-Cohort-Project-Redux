require 'scene'

require 'game_objects/asteroid'
require 'game_objects/background'
require 'game_objects/player'
#require 'game_objects/thruster'
require 'game_objects/laser_beam'
require 'game_objects/ufo'
require 'game_objects/game_hud'
require 'game_objects/ui_components/title'


module EdgeCollision
  module EdgeCollisionHandler
    def self.begin(a, b)
      if a.object
        a.object.display_ghost(b.collision_type, true)
      end
    end

    def self.separate(a, b)
      if a.object
        a.object.display_ghost(b.collision_type, false)
      end
    end
  end

  def self.create_universe_boundary(width, height, space, collision_types)
    edge = CP::Body.new_static()
    up_left = vec2(0, 0)
    up_right = vec2(width, 0)
    down_left = vec2(0, height)
    down_right = vec2(width, height)
    boundaries = {
      left_edge: CP::Shape::Segment.new(edge, up_left, down_left, 1),
      right_edge: CP::Shape::Segment.new(edge, up_right, down_right, 1),
      top_edge: CP::Shape::Segment.new(edge, up_left, up_right, 1),
      bottom_edge: CP::Shape::Segment.new(edge, down_left, down_right, 1)
    }
    boundaries.each_value {|value| value.sensor = true}
    boundaries.each {|key, value| value.collision_type = key }
    boundaries.each_value {|value| space.add_shape(value)}

    collision_types.each {|collision_type|
      boundaries.each_key {|key| space.add_collision_handler(collision_type, key, EdgeCollisionHandler)}
    }
  end
end

class GameScene < Scene
  attr_accessor :window, :lives, :score, :space
  def initialize(window)
    super

    @space = CP::Space.new()
    @space.damping = 0.8

    @lives = $CONFIG[:initialize_lives]
    @score = $CONFIG[:initialize_score]
    @game_duration = 0.0

    add_game_object Background.new(self, {
                       :image => $MEDIA_ROOT + "/Backgrounds/purple.png",
                       :music => $MEDIA_ROOT + "/Music/80s-Space-Game-Loop_v001.ogg"
    })

    add_game_object GameHUD.new(self)
    4.times { add_game_object Asteroid.new(self) }
    self._spawn_ufos
    add_game_object CharacterDialog.new(self, :duration => 5000)

    @player = Player.new(self)
    add_game_object @player
    @lasers = []

    #@thruster = Thruster.new(self)
    #add_game_object @thruster

    self._setup_collisions
  end

  def _setup_collisions
    @space.add_collision_func(:player, :ufo) {|player, ufo| player.object.destroy(@space); ufo.object.destroy(@space)}
    @space.add_collision_func(:player, :asteroid) {|player, asteroid| player.object.destroy(@space); asteroid.object.destroy(@space)}
    @space.add_collision_func(:laser, :ufo) {|laser, ufo|
      ufo.object.destroy(@space)
      laser.object.hit_target
      @score += 1000
    }

    @space.add_collision_func(:laser, :asteroid) {|laser, asteroid| 
      if asteroid.object
        laser.object.hit_target
        asteroid.object.destroy(@space) 
        @score += 100
      end
    }

    EdgeCollision.create_universe_boundary(self.width, self.height, @space, [:player_sensor, :ufo, :laser, :asteroid])
  end

  def _spawn_ufos
    ufos = []
    mother = UFO.new(self, :image_path => $CONFIG[:sprite_ufo][0], :follow => @player)
    ufos << mother
    3.times { ufos << mother.spawn_baby }

    ufos.each {|ufo|
      add_game_object ufo
      @space.add_body(ufo.shape.body)
      @space.add_shape(ufo.shape)
    }
  end

  def decrease_lives
    @lives -= 1
    if @lives == 0
      self.lose
    end
    @player.reset
  end

  def update
    super

    if Gosu::button_down? Gosu::KbRight
      @player.rotate(3)
    end
    if Gosu::button_down? Gosu::KbLeft
      @player.rotate(-3)
    end
    if Gosu::button_down? Gosu::KbUp
      @player.thrust(50)
    end
    if ((Gosu::button_down? Gosu::KbRightShift) || (Gosu::button_down? Gosu::KbLeftShift)) && !@shift_down
      @player.jump
      @shift_down = true
    end

    if !(Gosu::button_down? Gosu::KbRightShift) && !(Gosu::button_down? Gosu::KbLeftShift)
      @shift_down = false
    end

    if (Gosu::button_down? Gosu::KbSpace) && !@space_down
      laser = Laser_Beam.new(self)
      @player.fire(laser)
      
      @lasers << laser
      @space_down = true
    end
  
    if !Gosu::button_down? Gosu::KbSpace
      @space_down = false
    end

    @space.step(1.0/60.0)

    @game_duration += self.update_interval
    @score += self.update_interval / 1000.0

    @lasers.each(&:update)
    @lasers.each { |laser|
      if laser.reached_range?
        @lasers.delete(laser)
        laser.remove_from_game
      end
    }

    if self.win? and not @win
      self.win unless @win
      @win = true
    end

    #@thruster.update
    if @lose
      #Add timer delay
      @timer ||= 5000
      @timer -= self.update_interval

      if @timer > 0
        return self
      end

      if @space
        @space.add_post_step_callback(self.object_id.to_s.to_sym) do |space, key|
          game_objects.each {|o|
              if o.respond_to?('shapes') && o.respond_to?('bodies') then
                o.body.activate
                for s in o.shapes
                  @space.remove_shape(s)
                end
                for b in o.bodies
                  @space.remove_body(b)
                end
              end
          }
          @space = nil
        end
        return self
      else
        return nil
      end
    else
      return self
    end
  end

  def draw
    super
    
    @lasers.each(&:draw)

    self
  end

  def button_down(id)

  end

  def button_up(id)

  end

  def lose
    return if @lose

    add_game_object Title.new(self, text: "YOU LOSE FOOL!")
    @lose = true
  end

  def win?
    enemies = self.game_objects.select{|o| o.is_a? Asteroid or o.is_a? UFO}

    enemies.empty?
  end

  def win 
    add_game_object Title.new(self, text: "YOU WIN? CHEATER")
  end

end
