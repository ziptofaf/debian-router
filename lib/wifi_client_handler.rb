class WifiClientHandler

  attr_reader :networks
  require 'open3'
  def initialize

    raise 'No Wifi adapter available' unless isWifiAvailable
    @networks = Array.new
    @wlanAdapterName = findWlanAdapterName
    refresh
  end

  def refresh
    command = "iwlist #{@wlanAdapterName} scan | grep -i -e 'ESSID' -e 'Quality' -e 'Encryption'"
    stdout = Open3.capture2(command)
    lines = stdout[0].split("\n")
    numberOfNetworks = lines.count/3
    if numberOfNetworks==0
      @networks.clear
    else
      @networks.clear
      numberOfNetworks.times do |iteration|
        input = Array.new
        input[0] = lines[iteration*3]
        input[1] = lines[iteration*3+1]
        input[2] = lines[iteration*3+2]
        if (input[2].include?("ESSID:")) #this can actually be in reverse order on some network cards. Yes.
        else
          buffer = input[2]
          input[2] = input[0]
          input[0] = buffer
        end
        @networks.push(singleNetworkEntry(input))
      end
    end
  end

  def connectString(ssid, password = "", ip = "", gateway = "", netmask = "255.255.255.0")
    result = ""
    #this thing will simply give you the text to shove into /etc/network/interfaces. Yes. Disable NetworkManager or any equivalent if you dont want things to blow up. And restart computer.
    if (password.empty?)
      if (ip.empty?)
        result+= "iface #{@wlanAdapterName} inet dhcp\n"
        result+= "wireless-essid #{ssid}\n"
        result+= "wireless-mode Managed"
      else
        result+= "iface #{@wlanAdapterName} inet static\n"
        result+="address #{ip}\n"
        result+="gateway #{gateway}\n"
        result+="netmask #{netmask}\n"
        result+= "wireless-essid #{ssid}\n"
        result+= "wireless-mode Managed"
      end
    else
      result = "auto #{@wlanAdapterName}\n"
      if (ip.empty?)
        result+= "iface #{@wlanAdapterName} inet dhcp\n"
        result+="wpa-ssid \"#{ssid}\"\n"
        result+="wpa-psk \"#{password}\"\n"
      else
        result+= "iface #{@wlanAdapterName} inet static\n"
        result+="address #{ip}\n"
        result+="gateway #{gateway}\n"
        result+="netmask #{netmask}\n"
        result+="wpa-ssid \"#{ssid}\"\n"
        result+="wpa-psk \"#{password}\"\n"
      end
    end
    return result
  end

  def disconnect
    command = "dhclient -r #{@wlanAdapterName}" #warning! This won't run without root rights!
    Open3.capture2(command)
  end

  def details
    command = "iwconfig | grep  -e 'ESSID' -e 'Link Quality' -e 'Encryption'"
    stdout = Open3.capture2(command)
    index = stdout[0].index("#{@wlanAdapterName}")
    stringed = stdout[0].slice(index+@wlanAdapterName.length, stdout[0].length)
    stringed = stringed.split("\n")
    result = Hash.new
    index = stringed[0].index("ESSID:")
    result[:essid] = (stringed[0].slice(index+7, stringed[0].length-1).split)[0].chop
    encryption = stringed[1].split(":")[1]
    if (encryption=='on')
      encryption=true
    else
      encryption=false
    end
    result[:encryption]=encryption
    quality = stringed[2].index("Quality=")
    quality = stringed[2].slice(quality+8, stringed[2].length).split(" ")[0]
    result[:quality]=quality
    result[:quality_rate] = changeQualityToPercentage(quality)
    result
  end

private

  def singleNetworkEntry(input)
    entry = Hash.new
    quality = input[0].index("Quality=")
    quality = input[0].slice(quality+8, input[0].length).split(" ")[0]
    entry[:quality]=quality
    if entry[:quality]=="0/100" #this should be impossible and if it happens its because of invalid wifi card drivers, use signal strength in this case instead!
      quality = input[0].index("level=")
      quality = input[0].slice(quality+6, input[0].length).split(" ")[0]
      entry[:quality]=quality
    end
    entry[:quality_rate] = changeQualityToPercentage(quality)

    encryption = input[1].split(":")[1]
    if (encryption=='on')
      encryption=true
    else
      encryption=false
    end
    entry[:encryption]=encryption

    essid = input[2].index("ESSID:")
    essid = input[2].slice(essid+7, input[2].length-1).chop #chop to remove last character which is always "
    entry[:essid] = essid

    return entry
  end

  def isWifiAvailable #if its not - it will return an exception upon initialization. Can't use this lib without working adapter
    stdout = Open3.capture2("ifconfig | grep 'wlan'")
    return true if stdout[0].split("\n").length >= 1 #this actually gives the number of wlan adapters
    return false
  end

  def findWlanAdapterName
    stdout = Open3.capture2("ifconfig | grep 'wlan'")
    return stdout[0].split[0]
  end

  def changeQualityToPercentage(string)
    numbers = string.split("/")
    part1 = numbers[0].to_f
    part2 = numbers[1].to_f
    return (part1/part2).round(3)
  end
end
