@echo off
title Dart Shooter
cd ../web/
start "" "C:/Program Files/Dart/chromium/chrome.exe" --app=file://%CD%/index.html
