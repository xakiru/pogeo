#!/usr/bin/env bash

cd travis
brew uninstall python3
brew install --build-bottle python@3.5.rb
brew bottle python@3.5
curl --upload-file python*bottle* https://transfer.sh/
cd ..
