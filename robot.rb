class Robot

  @@commands_regex = /^MOVE$|^LEFT$|^RIGHT$|^REPORT$|^PLACE\s\d,\d,(NORTH|SOUTH|EAST|WEST)$/
  @@commands_array = []

  def self.load_commands (filename)
    file = File.open(filename, "r") rescue nil
    return if file.nil?
    while (line = file.gets)
      match_data = @@commands_regex.match(line)
      puts match_data[0] if match_data
    end
  end

end