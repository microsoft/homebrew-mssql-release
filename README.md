brew formulae for
  - Microsoft ODBC Driver for SQL Server
  - SQL Server Command Line Utilities

Run the following code in terminal to install (for OS X 10.11 (El Capitan) and macOS 10.12 (Sierra)):
```
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew tap microsoft/mssql-release https://github.com/Microsoft/homebrew-mssql-release
brew update
brew install --no-sandbox msodbcsql mssql-tools
```

Source: https://docs.microsoft.com/en-us/sql/connect/odbc/linux-mac/installing-the-microsoft-odbc-driver-for-sql-server
