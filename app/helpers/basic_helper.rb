module BasicHelper
  require 'mac-address'
  require 'sysinfo'
  require 'open3' #the module to have a sanitized input/output from system calls so we won't have HDD formatted or something similar by mistake
  require 'usagewatch'
  require 'sys/filesystem'
  def getMacs
    MacAddress.address.list
  end

  def wifiAvailable?
    stdout = Open3.capture2("ifconfig | grep 'wlan'")
    return true if stdout[0].split("\n").length #this actually gives the number of wlan adapters
    return false
  end

  def uptime
    uptime = uptimeHours
    formatted = Hash.new
    formatted[:hours] = uptime.to_i
    formatted[:minutes] = (uptime*60%60)
    formatted[:seconds] = ((uptime*3600%3600)%60).to_i
    formatted[:minutes] = formatted[:minutes].to_i
    return formatted
  end
  
  def cores
    core_count = Open3.capture2("nproc")
    core_count = core_count[0].to_i
    core_count
  end

  def systemLoad
    avg_load = Open3.capture2("uptime")
    index = avg_load[0].index('load average:')
    avg_load = avg_load[0].slice(index+14, 4)
    avg_load[","]="."
    return avg_load.to_f/cores #avg_load can easily exceed 1.00 and should be divided by core count if you want something that makes sense
  end
  private

  def uptimeHours
    sysinfo = SysInfo.new
    return sysinfo.uptime
  end

  def freeSpace
    stat = Sys::Filesystem.stat("/")
    mb_available = stat.block_size * stat.blocks_available / 1024 / 1024
    mb_available
  end
  def topProcesses
    usw = Usagewatch
    usw.uw_cputop
  end
end
