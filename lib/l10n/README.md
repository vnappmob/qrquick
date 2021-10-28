## How to contribute on translation

- Fork this project
- Go to [lib/l10n](l10n) directory
- Create new file with name like app_{locale_code}.arb where locale_code would be something like es (for Español), ja (for Japanese)...
- Copy content from app_en.arb to your new file
- Start your translation on the right side of ":", for example: "hello": "Hello" -> "hello": "Hola"
- Commit your file as new branch named: locale-{code}, eg: locale-es
- Create a [pull request](https://github.com/vnappmob/qrquick/pull/new/master) to merge your work to master branch
