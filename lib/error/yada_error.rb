#
# Author: ferbass
#

class YadaError < StandardError; end
class YadaSyntaxError < YadaError; end
class YadaRuntimeError < YadaError; end
class YadaUndefinedVariable < YadaError; end
class YadaUndefinedFunction < YadaError; end

