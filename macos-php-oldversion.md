# Brew tap
## https://github.com/shivammathur/homebrew-extensions
shivammathur/extensions
## https://github.com/shivammathur/homebrew-php
shivammathur/php

# install php
brew tap shivammathur/php
brew install shivammathur/php@{PHP_VERSION}

# install php-extension
brew tap shivammathur/extensions
brew update
brew install shivammathur/extensions/mcrypt@{PHP_VERSION}
## type "extension=/path/to/mcrypt.so" into php.ini manually
