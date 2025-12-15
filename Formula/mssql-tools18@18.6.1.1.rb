class MssqlTools18AT18611 < Formula
  desc "Sqlcmd and Bcp for Microsoft(R) SQL Server(R)"
  homepage "https://msdn.microsoft.com/en-us/library/ms162773.aspx"
  url Hardware::CPU.arch == :arm64 ? "https://download.microsoft.com/download/dba30481-34d1-42a3-9d52-8c9b33f21169/mssql-tools18-18.6.1.1-arm64.tar.gz" :
                                     "https://download.microsoft.com/download/dba30481-34d1-42a3-9d52-8c9b33f21169/mssql-tools18-18.6.1.1-amd64.tar.gz"
  version "18.6.1.1"
  sha256 Hardware::CPU.arch == :arm64 ? "3e8426e0e36c2d20770cd360f64279762ab920527c0f038dde4c66d578e9f910" :
                                        "e295892e9c1e0175da0bda2f99647036e18874824f87e8e540399b450eeda647"

  depends_on "msodbcsql18"

  def check_eula_acceptance?
    if ENV["HOMEBREW_ACCEPT_EULA"] != "y" && ENV["HOMEBREW_ACCEPT_EULA"] != "Y"
      puts "The license terms for this product can be downloaded from"
      puts "http://go.microsoft.com/fwlink/?LinkId=746949 and found in"
      puts "#{prefix}/share/doc/mssql-tools18/LICENSE.txt . By entering 'YES',"
      puts "you indicate that you accept the license terms."
      puts ""
      loop do
        puts "Do you accept the license terms? (Enter YES or NO)"
        accept_eula = STDIN.gets.chomp
        if accept_eula
          break if accept_eula.casecmp("YES").zero?
          if accept_eula.casecmp("NO").zero?
            puts "Installation terminated: License terms not accepted."
            return false
          else
            puts "Please enter YES or NO"
          end
        else
          puts "Installation terminated: Could not prompt for license acceptance."
          puts "If you are performing an unattended installation, you may set"
          puts "HOMEBREW_ACCEPT_EULA to Y to indicate your acceptance of the license terms."
          return false
        end
      end
    end
    true
  end

  def install
    return false unless check_eula_acceptance?

    chmod 0444, "bin/sqlcmd"
    chmod 0444, "bin/bcp"
    chmod 0444, "share/resources/en_US/BatchParserGrammar.dfa"
    chmod 0444, "share/resources/en_US/BatchParserGrammar.llr"
    chmod 0444, "share/resources/en_US/bcp.rll"
    chmod 0444, "share/resources/en_US/SQLCMD.rll"
    chmod 0644, "usr/share/doc/mssql-tools18/LICENSE.txt"
    chmod 0644, "usr/share/doc/mssql-tools18/THIRDPARTYNOTICES.txt"

    cp_r ".", prefix.to_s
  end

  test do
    out = shell_output("#{bin}/sqlcmd -?")
    assert_match "Microsoft (R) SQL Server Command Line Tool", out
    out = shell_output("#{bin}/bcp -v")
    assert_match "BCP - Bulk Copy Program for Microsoft SQL Server", out
  end
end
