# The Fish shell stores history entries in YAML format as follows:
# - cmd: <command text>
#   when: <timestamp>

# For example:
# - cmd: ls
#   when: 1625256723

# The Zsh shell, on the other hand, requires a different format for its history entries:
# ': <timestamp>:0;<command text>'

# So, the script converts the Fish format:
# - cmd: ls
#   when: 1625256723

# Into the Zsh format:
# ': 1625256723:0;ls'

class FishToZshHistoryMigrator
  def initialize(fish_history_path = nil, zsh_history_path = nil)
    @fish_history_path = fish_history_path || File.join(user_home, '.local', 'share', 'fish', 'fish_history')
    @zsh_history_path = zsh_history_path || File.join(user_home, '.zsh_history')

    raise "Fish history file does not exist at #{@fish_history_path}" unless File.exist?(@fish_history_path)
    raise "Zsh history file does not exist at #{@zsh_history_path}" unless File.exist?(@zsh_history_path)
  end

  def migrate
    content = parse_fish_history.join("\n") + "\n"
    File.write(@zsh_history_path, content, mode: 'a')
    puts 'Migration completed successfully.'
  rescue => e
    puts "Error during migration: #{e.message}"
    exit(1)
  end

  private

  def user_home
    ENV['HOME'] || ENV['USERPROFILE'] || (raise 'Home directory not found')
  end

  def parse_fish_history
    entries = []
    command_entry = {}
    File.foreach(@fish_history_path) do |line|
      case line.strip
      when /- cmd: (.+)/
        entries << format_for_zsh(command_entry) unless command_entry.empty?
        command_entry = {'cmd' => $1.strip}
      when /when: (.+)/
        command_entry['when'] = $1.strip.to_i
      end
    end
    entries << format_for_zsh(command_entry) unless command_entry.empty?
    entries.compact
  end

  def format_for_zsh(entry)
    command = entry['cmd']
    timestamp = entry['when']

    return unless command && timestamp

    ": #{timestamp}:0;#{command.to_s.gsub(/\\\\/, '\\').gsub(/\\n/, "\n")}"
  end
end

if __FILE__ == $0
  fish_history_path, zsh_history_path = ARGV
  FishToZshHistoryMigrator.new(fish_history_path, zsh_history_path).migrate
end
