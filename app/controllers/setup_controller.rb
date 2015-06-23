class SetupController < ApplicationController
  require 'wifi_client_handler'
  include BasicHelper

  def quicksetup
    @specs = Environment.safeFirst
    render "setup/quicksetup/quicksetup"
  end

  def advanced
    @specs = Environment.safeFirst
  end
end
