Sudo King
=========


### Required packages:

op command line tool: `brew install op`


### Required config file:

create a file with the following contents at `~/.sudoking/config`
```javascript
{
    "subdomain": "my", //subdomain, this is an example for my.1password.com
    "email": "email@example.com",
    "secretKey": "XX-XXXXXX-XXXXXX-XXXXX-XXXXX-XXXXX-XXXXX", // secret key given by 1password
    "pathToOPBinary": "/usr/local/bin/op",
    "sessionExpirationMinutes": 10 // number of minutes before it prompts for your password again up to 30 minutes
}
```


### Build Release:
```bash
xcodebuild -project SudoKing.xcodeproj
```

### Making it work in Iterm

Assuming you have the SudoKing code in your `~/Developer` folder
Add a keyboard shortcut to iterm and choose the `Run Coprocess` command that runs the following:
/Users/$USER/Developer/SudoKing/build/Release/SudoKing.app/Contents/MacOS/SudoKing
