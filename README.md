Sudo Like An OP
===============


### Required packages:

op command line tool: `brew install op`


### Required config file:

create a file with the following contents at `~/.sudolikeanop/config`
```json
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
xcodebuild -project SudoLikeAnOP.xcodeproj
```

### Making it work in Iterm

Assuming you have the SudoLikeAnOP code in your `~/Developer` folder
Add a keyboard shortcut to iterm and choose the `Run Coprocess` command that runs the following:
/Users/$USER/Developer/SudoLikeAnOP/build/Release/SudoLikeAnOP.app/Contents/MacOS/SudoLikeAnOP
