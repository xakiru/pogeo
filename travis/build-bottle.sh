#!/usr/bin/env bash

set -e

cd travis
brew uninstall python3
xcode-select --install || TRUE
brew install --build-bottle python@3.5.rb
brew bottle python@3.5
curl --upload-file python*bottle* https://transfer.sh/
cd ..
