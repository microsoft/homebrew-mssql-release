class MssqlTools < Formula
  desc "Sqlcmd and Bcp for Microsoft(R) SQL Server(R)"
  homepage "https://msdn.microsoft.com/en-us/library/ms162773.aspx"
  url "https://go.microsoft.com/fwlink/?linkid=848963"
  version "14.0.6.0"
  sha256 "b31cfe98ff3c8f60a98fd02a1ebbe7cf7a2172320239adccd073ad3870786bf9"

  depends_on "unixodbc"
  depends_on "openssl"
  depends_on "msodbcsql"

  def check_eula_acceptance?
    if ENV["ACCEPT_EULA"] != "y" && ENV["ACCEPT_EULA"] != "Y"
      puts "The license terms for this product can be downloaded from"
      puts "http://go.microsoft.com/fwlink/?LinkId=746949 and found in"
      puts "/usr/local/share/doc/mssql-tools/LICENSE.txt . By entering 'YES',"
      puts "you indicate that you accept the license terms."
      puts ""
      loop do
        puts "Do you accept the license terms? (Enter YES or NO)"
        accept_eula = STDIN.gets.chomp
        if accept_eula
          break if accept_eula == "YES"
          if accept_eula == "NO"
            puts "Installation terminated: License terms not accepted."
            return false
          else
            puts "Please enter YES or NO"
          end
        else
          puts "Installation terminated: Could not prompt for license acceptance."
          puts "If you are performing an unattended installation, you may set"
          puts "ACCEPT_EULA to Y to indicate your acceptance of the license terms."
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
