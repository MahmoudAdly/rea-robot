class Robot

  # One regulat expression for all possible commands
  COMMANDS_REGEX = /^MOVE$|^LEFT$|^RIGHT$|^REPORT$|^PLACE\s\d,\d,(NORTH|SOUTH|EAST|WEST)$/
  
  # The robot's face direction will decide the way it moves on the table.
  # Origin is bottm left. X axis goes to the right. Y axis goes up.
  FACES = {
    'EAST' => {:x=>1, :y=>0},
    'SOUTH' => {:x=>0, :y=>-1},
    'WEST' => {:x=>-1, :y=>0},
    'NORTH' => {:x=>0, :y=>1}
  }

  def initialize()
    reset_robot
    set_table_size
  end

  def set_table_size(table_w=5, table_h=5)
    @table_w = table_w
    @table_h = table_h
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

    # Start at origin, looking EAST.
    @face = FACES.keys[0]
    @location = {:x=>0, :y=>0}
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
      rotate(true)
    when 'RIGHT'
      rotate
    when 'REPORT'
      report
    else
      # none
    end
  end

  def place(params_string)
    params = params_string.split(',')
    new_location = {:x=>params[0].to_i,:y=>params[1].to_i}
    new_face = params[2]

    if valid_location?(new_location) && FACES.keys.include?(new_face)
      @location = new_location
      @face = new_face
    else
      puts 'Invalid Place'
    end
  end

  def move
    new_location = {
      :x=>@location[:x]+FACES[@face][:x],
      :y=>@location[:y]+FACES[@face][:y]
    }
    if valid_location?(new_location)
      @location = new_location
    else
      puts 'Invalid move.'
    end
  end

  def rotate(counter_clock=false)
    direction = counter_clock == false ? 1 : -1
    @face = FACES.keys[(FACES.keys.index(@face)+direction)%FACES.size]
  end

  def report
    puts "%{x},%{y},%{face}" % {
      :x=>@location[:x],
      :y=>@location[:y],
      :face=>@face}
  end

  def valid_location?(location)
    location[:x].between?(0, @table_w-1) && location[:y].between?(0, @table_h-1)
  end

end