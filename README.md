# DroidVenom

![Made with Perl](https://img.shields.io/badge/made%20with-perl-0.svg?color=cc2020&labelColor=ff3030&style=for-the-badge)

![GitHub](https://img.shields.io/github/license/DeBos99/droidvenom.svg?color=2020cc&labelColor=5050ff&style=for-the-badge)
![GitHub followers](https://img.shields.io/github/followers/DeBos99.svg?color=2020cc&labelColor=5050ff&style=for-the-badge)
![GitHub forks](https://img.shields.io/github/forks/DeBos99/droidvenom.svg?color=2020cc&labelColor=5050ff&style=for-the-badge)
![GitHub stars](https://img.shields.io/github/stars/DeBos99/droidvenom.svg?color=2020cc&labelColor=5050ff&style=for-the-badge)
![GitHub watchers](https://img.shields.io/github/watchers/DeBos99/droidvenom.svg?color=2020cc&labelColor=5050ff&style=for-the-badge)
![GitHub contributors](https://img.shields.io/github/contributors/DeBos99/droidvenom.svg?color=2020cc&labelColor=5050ff&style=for-the-badge)

![GitHub commit activity](https://img.shields.io/github/commit-activity/w/DeBos99/droidvenom.svg?color=ffaa00&labelColor=ffaa30&style=for-the-badge)
![GitHub commit activity](https://img.shields.io/github/commit-activity/m/DeBos99/droidvenom.svg?color=ffaa00&labelColor=ffaa30&style=for-the-badge)
![GitHub commit activity](https://img.shields.io/github/commit-activity/y/DeBos99/droidvenom.svg?color=ffaa00&labelColor=ffaa30&style=for-the-badge)
![GitHub last commit](https://img.shields.io/github/last-commit/DeBos99/droidvenom.svg?color=ffaa00&labelColor=ffaa30&style=for-the-badge)

![GitHub issues](https://img.shields.io/github/issues-raw/DeBos99/droidvenom.svg?color=cc2020&labelColor=ff3030&style=for-the-badge)
![GitHub closed issues](https://img.shields.io/github/issues-closed-raw/DeBos99/droidvenom.svg?color=10aa10&labelColor=30ff30&style=for-the-badge)

[![Donate](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=NH8JV53DSVDMY)

**DroidVenom** is simple perl script for creating custom payload for android.

## Content

- [Content](#content)
- [Features](#features)
- [Installation](#installation)
  - [Debian/Ubuntu](#apt)
  - [Arch Linux/Manjaro](#pacman)
- [Usage](#usage)
- [Documentation](#documentation)
  - [Optional arguments](#optional-arguments)
- [Disclaimer](#disclaimer)
- [Authors](#authors)
- [Contact](#contact)
- [License](#license)

## Features

* Custom IP address and port.
* Custom name and icon for generated application.
* Custom payload.
* Custom permissions.
* Custom features.
* Custom key file.

## Installation

### <a name="APT">Debian/Ubuntu based

* Run following commands in the terminal:
```
sudo apt install git perl metasploit-framework default-jdk -y
export apktool_version=2.4.0
sudo -E sh -c 'wget https://bitbucket.org/iBotPeaches/apktool/downloads/apktool_$apktool_version.jar -O /usr/local/bin/apktool.jar'
sudo chmod +r /usr/local/bin/apktool.jar
sudo sh -c 'wget https://raw.githubusercontent.com/iBotPeaches/Apktool/master/scripts/linux/apktool -O /usr/local/bin/apktool'
sudo chmod +x /usr/local/bin/apktool
git clone "https://github.com/DeBos99/droidvenom.git"
```

### <a name="Pacman">Arch Linux/Manjaro

* Run following commands in the terminal:
```
sudo pacman -S git perl metasploit-framework jdk-openjdk --noconfirm
git clone "https://aur.archlinux.org/android-apktool.git"
cd android-apktool
makepkg -cfis --noconfirm
cd ..
rm -rf android-apktool
git clone "https://github.com/DeBos99/droidvenom.git"
```

## Usage

`perl main.pl ARGUMENTS`

## Documentation

### Optional arguments

| Argument                  | Description                                | Default value                   |
| :------------------------ | :----------------------------------------- | :------------------------------ |
| -h, --help                | Shows help message and exits.              |                                 |
| -v, --version             | Shows version and exits.                   |                                 |
| -i, --ip IP               | Sets IP address.                           | 0.0.0.0:80                      |
| -n, --name NAME           | Sets application name and output filename. | Application                     |
| -o, --output PATH         | Sets path to output file.                  | application.apk                 |
| -p, --payload PAYLOAD     | Sets payload.                              | android/meterpreter/reverse_tcp |
| -P, --permissions PATH    | Sets path to file with permissions.        | permissions.txt                 |
| -F, --features PATH       | Sets path to file with features.           | features.txt                    |
| -I, --icons PATH          | Sets path to directory with icons.         |                                 |
| -s, --sigalg ALGORITHM    | Sets name of signature algorithm.          | SHA1withRSA                     |
| -d, --digestalg ALGORITHM | Sets name of digest algorithm.             | SHA1                            |
| -k, --key PATH            | Sets path to file with key.                | my-release-key.keystore         |

## Disclaimer

**DroidVenom** was created for educational purposes and I'm not taking responsibility for any of your actions.

## Authors

* **Michał Wróblewski** - Main Developer - [DeBos99](https://github.com/DeBos99)

## Contact

Discord: DeBos#3292

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
