Brew formulae for
  - Microsoft ODBC Driver for SQL Server
  - SQL Server Command Line Utilities

MacOS installation:
````
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew tap microsoft/mssql-release https://github.com/Microsoft/homebrew-mssql-release
brew update
brew install msodbcsql17 mssql-tools
````

For more installation instructions, see the [Microsoft ODBC Driver for SQL Server documentation](https://docs.microsoft.com/en-us/sql/connect/odbc/linux-mac/installing-the-microsoft-odbc-driver-for-sql-server#os-x-1011-el-capitan-and-macos-1012-sierra).
