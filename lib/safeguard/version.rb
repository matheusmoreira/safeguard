module Safeguard

  # Contains the current version of Safeguard.
  module Version

    # Major version.
    #
    # Increments denote backward-incompatible changes and additions.
    MAJOR = 0

    # Minor version.
    #
    # Increments denote backward-compatible changes and additions.
    MINOR = 1

    # Patch version.
    #
    # Increments denote changes in implementation.
    PATCH = 1

    # Build version.
    #
    # Used for pre-release versions.
    BUILD = nil

    # Complete version string, which is every individual version number joined
    # by a dot ('.'), in descending order of prescedence.
    STRING = [ MAJOR, MINOR, PATCH, BUILD ].compact.join '.'

  end
end
