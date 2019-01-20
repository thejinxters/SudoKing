Sudo King
=========

Access 1Password from iTerm, with this [1Password Cli](https://support.1password.com/command-line/) wrapper

## Getting Set Up

Install `op` and `sudoking` via homebrew:
```bash
brew cask install 1password-cli
brew install thejinxters/sudoking/sudoking
```
In your terminal, run:
```bash
sudoking --configure
```
SudoKing will then prompt you for the following settings and creating a settings file. 
This file is located at `~/.sudoking/config` and looks like this:
```javascript
{
    "subdomain": "my", //subdomain, this is an example for my.1password.com
    "email": "email@example.com",
    "secretKey": "XX-XXXXXX-XXXXXX-XXXXX-XXXXX-XXXXX-XXXXX", // secret key given by 1password
    "pathToOPBinary": "/usr/local/bin/op",
    "sessionExpirationMinutes": 10 // number of minutes before it prompts for your password again up to 30 minutes
}
```
You're now ready to configure iTerm to use `sudoking`

## Configure [iterm2](https://iterm2.com) to use `sudoking`

After installing `sudoking`, you still need to configure [iterm2](https://iterm2.com). Just follow the instructions in the gif below:

![configuration directions](https://raw.githubusercontent.com/thejinxters/SudoKing/master/img/sudoking-configure-iterm.gif)

## Developer

### Build Release:
```bash
homebrew/version.sh <release_version>
```
