#!/usr/bin/env bash

set -e

cd travis
brew uninstall python3
brew install --build-bottle python35.rb
brew bottle --force-core-tap python35
curl --upload-file python*bottle* https://transfer.sh/
cd ..
