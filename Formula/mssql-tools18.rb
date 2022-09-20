class MssqlTools18 < Formula
  desc "Sqlcmd and Bcp for Microsoft(R) SQL Server(R)"
  homepage "https://msdn.microsoft.com/en-us/library/ms162773.aspx"
  url Hardware::CPU.arch == :arm64 ? "https://download.microsoft.com/download/6/4/0/64006503-51e3-44f0-a6cd-a9b757d0d61b/mssql-tools18-18.1.1.1-arm64.tar.gz" :
                                     "https://download.microsoft.com/download/6/4/0/64006503-51e3-44f0-a6cd-a9b757d0d61b/mssql-tools18-18.1.1.1-amd64.tar.gz"
  version "18.1.1.1"
  sha256 Hardware::CPU.arch == :arm64 ? "b134287cb646af1001dea69c0c007b0195f6e97914f6b838288eab4cc379fbb4" :
                                        "4a985a72a7bc5330a2b8d4c8297122470ae627ff4d74b1290fcd8385184c0aab"

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
