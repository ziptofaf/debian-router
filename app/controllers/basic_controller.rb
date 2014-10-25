class BasicController < ApplicationController
  include BasicHelper
  #skip_before_action :authorize
  def status
    @specs = Environment.safeFirst
    @macs = getMacs
  end

end
