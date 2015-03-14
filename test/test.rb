require "test/unit"
require File.expand_path("robot.rb")
 
class TestRobot < Test::Unit::TestCase
 
  def setup
    @robot = Robot.new
  end
 
  def test_a
    @robot.load_commands_from_file('./test/a.txt')
    @robot.start
    assert_equal('0,1,NORTH', @robot.execute('REPORT'))
  end
 
  def test_b
    @robot.load_commands_from_file('./test/b.txt')
    @robot.start
    assert_equal('0,0,WEST', @robot.execute('REPORT'))
  end

  def test_c
    @robot.load_commands_from_file('./test/c.txt')
    @robot.start
    assert_equal('3,3,NORTH', @robot.execute('REPORT'))
  end

end
