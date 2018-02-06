# Fact: myprogram_version
# Purpose: E.g. Report the version of some program
#
# This is Ruby code and can use any Ruby library
# See https://puppet.com/docs/facter/3.9/fact_overview.html for examples 
#

Facter.add(:some_program_version) do
  setcode do
    begin
      Facter::Util::Resolution.exec("some_program_version 2>&1").split("\n")[0].split(' ')[1] 
    rescue Exception
      Facter.debug('some_program_version not available')
    end
  end
end
