module BasicHelper
  require 'mac-address'
  require 'open3' #the module to have a sanitized input/output from system calls so we won't have HDD formatted or something similar by mistake
  def getMacs
    MacAddress.address.list
  end

  def wifiAvailable?
    stdout = Open3.capture2("ifconfig | grep 'wlan'")
    return true if stdout[0].split("\n").length #this actually gives the number of wlan adapters
    return false
  end
end
