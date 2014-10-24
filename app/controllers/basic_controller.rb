class BasicController < ApplicationController
  include BasicHelper
  def status
    Environment.setIfEmpty #this should be initialized by model itself before any finds
    @macs = getMacs
    @specs = Environment.first
  end

end
