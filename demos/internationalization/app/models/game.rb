class Game < ApplicationRecord
  # determine the correct result before saving
  before_save :determine_result 
  belongs_to :user

  enum threw: [:rock, :paper, :scissors], _prefix: :threw
  enum against: [:rock, :paper, :scissors], _prefix: :against
  enum result: [:loss, :draw, :win]

  # determine result
  def determine_result
    self.result = (4 + self.class.threws[threw] - self.class.againsts[against]) % 3
  end
  # perform a random move
  def self.move
    self.againsts.keys.sample.to_sym
  end
end
