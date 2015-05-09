class WifiHandler

  attr_reader :networks
  require 'open3'
  def initialize

    raise 'No Wifi adapter available' unless isWifiAvailable
    @networks = Array.new
    @wlanAdapterName = findWlanAdapterName
    refresh
  end

  def refresh
    command = "iwlist <insertName> scan | grep -i -e 'ESSID' -e 'Quality' -e 'Encryption'"
    command['<insertName>'] = @wlanAdapterName
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
        @networks.push(singleNetworkEntry(input))
      end
    end
  end

  def connect(id, password = "")
    #this thing will simply edit /etc/network/interfaces. Yes. Disable NetworkManager or any equivalent if you dont want things to blow up.
  end

  def disconnect
    command = "dhclient -r <insertName>" #warning! This won't run without root rights!
    command['<insertName>'] = @wlanAdapterName
    Open3.capture2(command)
  end

  def details

  end

  private

  def singleNetworkEntry(input)
    entry = Hash.new
    quality = input[0].index("Quality=")
    quality = input[0].slice(quality+8, input[0].length).split(" ")[0]
    entry[:quality]=quality
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
