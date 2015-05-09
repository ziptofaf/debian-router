class BasicController < ApplicationController
  require 'wifi_handler'
  include BasicHelper
  #skip_before_action :authorize
  def status
    @specs = Environment.safeFirst
    @macs = getMacs
    begin
    @uptime = uptime

  rescue => e
      @uptimeError = true
    end
    @systemLoad = (systemLoad*100).to_i
  end

end
