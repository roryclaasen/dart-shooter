@echo off
title Dart Shooter
cd ../web/
start "" "C:/Program Files/Dart/chromium/chrome.exe" --allow-file-access-from-files --app=file://%CD%/index.html
