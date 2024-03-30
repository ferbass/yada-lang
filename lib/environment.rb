#
# Yada Environment
# Author: ferbass
#
# This is a simple environment for the Yada language.

class Environment

  attr_reader :record

  #
  # Initialize the environment
  # @return [Environment] the environment
  #
  def initialize (record = {}, parent = nil)
    @record = record
    @parent = parent
  end

  #
  # Define a variable with given name and value
  # @param name [String] variable name
  # @param value [Object] variable value
  # @return [Object] the variable value
  #
  def define(name, value)
    @record[name] = value
    return value
  end


  #
  # Assign a variable with given name and value
  # @param name [String] variable name
  # @param value [Object] variable value
  # @return [Object] the variable value
  # @raise [NameError] if the variable is not found
  #
  def assign(name, value)
    resolve(name).record[name] = value
    return value
  end

  #
  # Lookup a variable with given name
  # @param name [String] variable name
  # @return [Object] the variable value
  # @raise [NameError] if the variable is not found
  #
  def lookup(name)
    return lookup_value(name)
  end

  #
  # Lookup a variable with given name
  # @param name [String] variable name
  # @return [Object] the variable value
  # @raise [Yada~UndefinedError] if the variable is not found
  # TODO:: Refactor error message to identify if it is class/variable/function etc
  #

  def lookup_value(name)
    if @record.key?(name)
      return @record[name]
    elsif @parent
      return @parent.lookup_value(name)
    else
      raise NameError.new("Yada~UndefinedError: Undefined '#{name}'")
    end
  end

  #
  # Resolve a variable with given name
  # @param name [String] variable name
  # @return [Environment] the environment
  # @raise [Yada~UndefinedError] if the variable is not found
  # TODO:: Refactor error message to identify if it is class/variable/function etc
  def resolve(name)
    if @record.key?(name)
      return self
    end
    if @parent
      return @parent.resolve(name)
    end
    raise NameError.new("Yada~UndefinedError: Undefined #{name}")
  end

end
