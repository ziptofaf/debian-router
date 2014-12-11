module WifiHelper
  def turn_on
    path = Rails.root.to_s + "/scripts/"
    stdout = Open3.capture2("#{path}/wifi_start")
    return true if stdout == 0
    return false
  end

  def turn_off
    path = Rails.root.to_s + "/scripts/"
    stdout = Open3.capture2("#{path}/wifi_stop")
    return true if stdout == 0
    return false
  end
end
