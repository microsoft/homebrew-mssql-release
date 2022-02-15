class MssqlTools18 < Formula
  desc "Sqlcmd and Bcp for Microsoft(R) SQL Server(R)"
  homepage "https://msdn.microsoft.com/en-us/library/ms162773.aspx"
  url Hardware::CPU.arch == :arm64 ? "https://download.microsoft.com/download/1/8/9/18909ac5-df3b-4743-9218-a990812141ec/mssql-tools18-18.0.1.1-arm64.tar.gz" :
                                     "https://download.microsoft.com/download/1/8/9/18909ac5-df3b-4743-9218-a990812141ec/mssql-tools18-18.0.1.1-amd64.tar.gz"
  version "18.0.1.1"
  sha256 Hardware::CPU.arch == :arm64 ? "360688af268a38ad9a253298e8258c15e89840d7b00125afb43df655e093c285" :
                                        "dabbbc3b7bfd5db94a7656b66e5180dda36e6ca6af7f5dd7b7311e87a49c5e7f"

  depends_on "msodbcsql18"

  def check_eula_acceptance?
    if ENV["ACCEPT_EULA"] != "y" && ENV["ACCEPT_EULA"] != "Y"
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
