require 'securerandom'

class SlickRun

  def self.srl_path_set?
    !!@@srl_path
  end

  def self.set_srl_path(srl_path)
    @@srl_path = srl_path
  end

  def self.add_magic_word(name, filename, params='', start_mode=1, use_run_as=0, disable_32bit_redir=0)
    throw "SlickRun.srl file could not be found automatically. Use set_srl_path to set it implicitly." unless @@srl_path
    magic_word_string = generate_magic_word_string(name, filename, params, start_mode, use_run_as, disable_32bit_redir)
    insert_magic_word_to_srl(magic_word_string, name)
  end

  private
  def self.generate_magic_word_string(name, filename, params, start_mode, use_run_as, disable_32bit_redir)
    name.gsub!(/[^A-Za-z]/, '') # Strip the name off invalid chars
    %Q{[#{name}]
Filename="#{filename}"
Params="#{params}"
GUID={#{SecureRandom.uuid.upcase}}
StartMode=#{start_mode}
UseRunAs=#{use_run_as}
Disable32BitRedir=#{disable_32bit_redir}
}          
  end

  def self.insert_magic_word_to_srl(magic_word, name)
    new_srl = ""
    magic_word_added = false
    File.open(@@srl_path, 'r') do |file|
      file.readlines.each do |line|

        # Shove the magic_word after the first magic word that is alphabetically bigger
        if not magic_word_added and match = line.match(/\[(.+)\]/)
          if name < match[1]
            new_srl += magic_word
            magic_word_added = true
          end
        end

        new_srl += line
      end
    end

    !!File.open(@@srl_path, "w") { |file| file.write(new_srl) }
  end

    # Searches for SlickRun.srl file in default locations
  def self.search_srl_path    
    vista_path = File.join(ENV["USERPROFILE"], 'AppData\Roaming\Slickrun\SlickRun.srl')    
    return vista_path if File.exists?(vista_path)

    xp_path = File.join(ENV["USERPROFILE"], 'Application Data\SlickRun\SlickRun.srl')
    return xp_path if File.exists?(xp_path)

    warn "[WARNING] Could not find SlickRun.srl file. Use set_srl_path to set it implicitly."
    nil
  end

  @@srl_path = self.search_srl_path

end