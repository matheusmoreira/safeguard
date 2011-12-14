require 'safeguard/digest'

module Safeguard

  def self.file(filename)
    Digest.file filename
  end

end
