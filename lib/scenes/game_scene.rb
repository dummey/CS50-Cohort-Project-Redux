
class GameScene
  attr_accessor :lives, :score
  def initialize
    self.lives = $CONFIG[:initialize_lives]
    self.score = $CONFIG[:initialize_score]
  end

end