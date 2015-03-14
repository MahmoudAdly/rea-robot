class Robot

  COMMANDS_REGEX = /^MOVE$|^LEFT$|^RIGHT$|^REPORT$|^PLACE\s\d,\d,(NORTH|SOUTH|EAST|WEST)$/
  
  def initialize()
    reset_robot
  end

  # Load commands from a text file, one command per line.
  # User can add more commands or start fresh using 'append'
  def load_commands_from_file(filename, append=false)
    file = File.open(filename, "r") rescue nil
    return if file.nil?
    
    reset_robot unless append

    while (line = file.gets)
      @commands_array << line if valid_command?(line)
    end
  end

  # Start applying previously-loaded commands.
  def start
    while @next_command_index < @commands_array.length
      apply_command(@commands_array[@next_command_index])
      @next_command_index += 1
    end
  end

  # Pass a command directly.
  def execute(command)
    if valid_command?(command)
      apply_command(command)
    else
      return 'Invalid command.'
    end
  end

  def valid_command?(command)
    match_data = COMMANDS_REGEX.match(command)
    if match_data
      return true
    else
      return false
    end
  end

  private

  # Reset any data related to the robot instance.
  def reset_robot
    @commands_array = []
    @next_command_index = 0

    # Robot robot should not move before getting PLACEd.
    @is_placed = false

    # Start looking right.
    @face = {:x => 0, :y => 1}
  end

  def apply_command(command)
    args = command.split(/\s/)
    order = args[0]
    params = args[1]

    case order
    when 'PLACE'
      place(params)
    when 'MOVE'
      move
    when 'LEFT'
      left
    when 'RIGHT'
      right
    when 'REPORT'
      report
    else
      # none
    end
  end

  def place(params)
    puts "PLACE (#{params})"
  end

  def move
    puts 'MOVE'
  end

  def left
    puts 'LEFT'
  end

  def right
    puts 'RIGHT'
  end

  def report
    puts 'REPORT'
  end

end