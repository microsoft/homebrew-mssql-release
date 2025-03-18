class Msodbcsql18 < Formula
  desc "ODBC Driver for Microsoft(R) SQL Server(R)"
  homepage "https://msdn.microsoft.com/en-us/library/mt654048(v=sql.1).aspx"
  url Hardware::CPU.arch == :arm64 ? "https://download.microsoft.com/download/c2f710a5-1166-4e74-a828-db4cdecde470/msodbcsql18-18.5.1.1-arm64.tar.gz" :
                                     "https://download.microsoft.com/download/c2f710a5-1166-4e74-a828-db4cdecde470/msodbcsql18-18.5.1.1-amd64.tar.gz"
  version "18.5.1.1"
  sha256 Hardware::CPU.arch == :arm64 ? "be707cec8f5de8a92b8d9f39e1bf1f2c289b20bf6aa32dd96a659cc27f55d41f" :
                                        "38dbac5c027c86ca3ab624362ac29062345af396459586dde6d743030fe7ac44"

  option "without-registration", "Don't register the driver in odbcinst.ini"


  depends_on "unixodbc"
  depends_on "openssl"

  def check_eula_acceptance?
    if ENV["HOMEBREW_ACCEPT_EULA"] != "y" && ENV["HOMEBREW_ACCEPT_EULA"] != "Y"
      puts "The license terms for this product can be downloaded from"
      puts "https://aka.ms/odbc18eula and found in"
      puts "#{prefix}/share/doc/msodbcsql18/LICENSE.txt . By entering 'YES',"
      puts "you indicate that you accept the license terms."
      puts ""
      loop do
        puts "Do you accept the license terms? (Enter YES or NO)"
        accept_eula = STDIN.gets.chomp
        if accept_eula
          if accept_eula.casecmp("YES").zero?
            break
          elsif accept_eula.casecmp("NO").zero?
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

    chmod 0444, "lib/libmsodbcsql.18.dylib"
    chmod 0444, "share/msodbcsql18/resources/en_US/msodbcsqlr18.rll"
    chmod 0644, "include/msodbcsql18/msodbcsql.h"
    chmod 0644, "odbcinst.ini"
    chmod 0644, "share/doc/msodbcsql18/LICENSE.txt"
    chmod 0644, "share/doc/msodbcsql18/RELEASE_NOTES"

    cp_r ".", prefix.to_s

    if build.with? "registration"
      system "odbcinst", "-u", "-d", "-n", "\"ODBC Driver 18 for SQL Server\""
      system "odbcinst", "-i", "-d", "-f", "./odbcinst.ini"
    end
  end

  def caveats; <<~EOS
    If you installed this formula with the registration option (default), you'll
    need to manually remove [ODBC Driver 18 for SQL Server] section from
    odbcinst.ini after the formula is uninstalled. This can be done by executing
    the following command:
        odbcinst -u -d -n "ODBC Driver 18 for SQL Server"
    EOS
  end

  test do
    if build.with? "registration"
      out = shell_output("#{Formula["unixodbc"].opt_bin}/odbcinst -q -d")
      assert_match "ODBC Driver 18 for SQL Server", out
    end
  end
end
