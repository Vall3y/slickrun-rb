require 'securerandom'

class SlickRun
  @@srl_path = self.search_srl_path

  def self.srl_path_set?
    !!@@srl_path
  end

  def self.set_srl_path(srl_path)
    @@srl_path = srl_path
  end

  def self.add_magic_word(name, filename, params='', start_mode=1, use_run_as=0, disable_32bit_redir=0)
    throw "SlickRun.srl file could not be found automatically. Use set_srl_path to set it implicitly." unless @@srl_path
    magic_word_string = generate_magic_word_string(name, filename, params, start_mode, use_run_as, disable_32bit_redir)    
    !!File.open(srl_path, 'a') { |file| file.write magic_word_string }
  end

  private
  def self.generate_magic_word_string(name, filename, params, start_mode, use_run_as, disable_32bit_redir)
    name.gsub!(/[^A-Za-z]/, '') # Strip the name off invalid chars
    %Q{
[#{name}]
Filename="#{filename}"
Params="#{params}"
GUID={#{SecureRandom.uuid.upcase}}
StartMode=#{start_mode}
UseRunAs=#{use_run_as}
Disable32BitRedir=#{disable_32bit_redir}}          
  end

  # Searches for SlickRun.srl file in default locations
  def self.search_srl_path    
    vista_path = File.join(ENV["USERPROFILE"], 'AppData\Roaming\Slickrun\SlickRun.srl')    
    xp_path = File.join(ENV["USERPROFILE"], 'Application Data\SlickRun\SlickRun.srl')

    return vista_path if vista_path
    return xp_path if xp_path

    warn "[WARNING] Could not find SlickRun.srl file. Use set_srl_path to set it implicitly."
    nil
  end
end