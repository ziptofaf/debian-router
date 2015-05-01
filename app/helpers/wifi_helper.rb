module WifiHelper
  def turn_on
    path = Rails.root.to_s + "/scripts/"
    stdout, status = Open3.capture2("#{path}/wifi_start")
    return true if status == 0
    return false
  end

  def turn_off
    path = Rails.root.to_s + "/scripts/"
    stdout, status = Open3.capture2("#{path}/wifi_stop")
    return true if status == 0
    return false
  end
end
