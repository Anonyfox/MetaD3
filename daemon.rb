require 'daemons'

file = File.expand_path(__FILE__).split("/")[0..-2].join("/") + "/MetaD3.rb"
 
 Daemons.run_proc(
   'background_service', # name of daemon
 #  :dir_mode => :normal
 #  :dir => File.join(pwd, 'tmp/pids'), # directory where pid file will be stored
 #  :backtrace => true,
 #  :monitor => true,
   :log_output => true
 ) do
   exec "ruby #{file}"
 end
