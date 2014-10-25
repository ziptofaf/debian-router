class Environment < ActiveRecord::Base
  require 'mac-address'
public
  def self.safeFirst #guaranteed to yield some results even if database was purged
    self.setIfEmpty
    self.first
  end

private
  def self.setIfEmpty
    if Environment.first.nil?
      env = Environment.new
      env.operating_system=RUBY_PLATFORM
      env.current_version="0.01" #temporary, will make it into something nice later
      env.adapter_count = MacAddress.address.list.count
      env.save
    end
  end
end
