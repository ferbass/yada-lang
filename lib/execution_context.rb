#
# Yada ExecutionContext
# Author: ferbass
#
# This is a simple execution context for the Yada language.
#
class ExecutionContext
  attr_reader :environment, :return_address

  def initialize(environment, return_address)
    @environment = environment
    @return_address = return_address
  end
end
