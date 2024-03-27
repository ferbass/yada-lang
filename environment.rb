#
# Yada Environment
# Author: ferbass
#
# This is a simple environment for the Yada language.

class Environment

  #
  # Initialize the environment
  # @return [Environment] the environment
  #
  def initialize
    @record = {}
  end

  #
  # Define a variable with given name and value
  # @param name [String] variable name
  # @param value [Object] variable value
  def define(name, value)
    @record[name] = value
    return value
  end



end
