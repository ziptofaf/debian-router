class BasicController < ApplicationController
  include BasicHelper
  #skip_before_action :authorize
  def status
    @specs = Environment.safeFirst
    @macs = getMacs
    @uptime = uptime
    @systemLoad = (systemLoad*100).to_i
  end

end
