class WifiController < ApplicationController
  include WifiHelper

  def status

  end

  def wifi_on
    if turn_on
      flash[:info]="WiFi has been enabled" and redirect_to wifi_status_path and return
    else
      flash[:info]="Something went wrong" and redirect_to wifi_status_path and return
    end
  end

  def wifi_off
    if turn_off
      flash[:info]="WiFi has been disabled" and redirect_to wifi_status_path and return
    else
      flash[:info]="Something went wrong" and redirect_to wifi_status_path and return
    end
  end
end
