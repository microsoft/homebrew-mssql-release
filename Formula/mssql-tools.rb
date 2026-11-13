class MssqlTools < Formula
  desc "Sqlcmd and Bcp for Microsoft(R) SQL Server(R)"
  homepage "https://msdn.microsoft.com/en-us/library/ms162773.aspx"
  url Hardware::CPU.arch == :arm64 ? "https://download.microsoft.com/download/036230e0-73bf-47cb-ac0e-8a09612cb66b/mssql-tools-17.12.1.1-arm64.tar.gz" :
                                     "https://download.microsoft.com/download/036230e0-73bf-47cb-ac0e-8a09612cb66b/mssql-tools-17.12.1.1-amd64.tar.gz"
  version "17.12.1.1"
  sha256 Hardware::CPU.arch == :arm64 ? "c0bfc662e9b9e04ea480b87c040de1205e7be2d24e3af91c67f1fce4814a0a8a" :
                                        "e8faaab48a39b0949c02e5d5d7c91fffbca37b1c36de83d0769203c8c4666662"

  depends_on "unixodbc"
  depends_on "openssl"
  depends_on "msodbcsql17"

  def check_eula_acceptance?
    if ENV["HOMEBREW_ACCEPT_EULA"] != "y" && ENV["HOMEBREW_ACCEPT_EULA"] != "Y"
      puts "The license terms for this product can be downloaded from"
      puts "http://go.microsoft.com/fwlink/?LinkId=746949 and found in"
      puts "/usr/local/share/doc/mssql-tools/LICENSE.txt . By entering 'YES',"
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
    chmod 0644, "usr/share/doc/mssql-tools/LICENSE.txt"
    chmod 0644, "usr/share/doc/mssql-tools/THIRDPARTYNOTICES.txt"

    cp_r ".", prefix.to_s
  end

  test do
    out = shell_output("#{bin}/sqlcmd -?")
    assert_match "Microsoft (R) SQL Server Command Line Tool", out
    out = shell_output("#{bin}/bcp -v")
    assert_match "BCP - Bulk Copy Program for Microsoft SQL Server", out
  end
end
