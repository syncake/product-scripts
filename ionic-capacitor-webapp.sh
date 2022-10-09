#!/bin/bash

# node v14 required

# capacitor installation
# url: https://capacitorjs.com/docs/getting-started
mkdir webapp && cd webapp

npm init @capacitor/app
npm i @capacitor/core
npm i -D @capacitor/cli

npx cap init
npm i @capacitor/android
npx cap add android

mkdir dist
npx cap sync

## icon & splash updated
## url: https://stackoverflow.com/questions/60549868/ionic-5-how-to-replace-default-icon-and-splash-screen-image-and-generate-resou
## comment: make sure directory resources exists and Add your icon.png (1024x1024 px) and splash.png (2732x2732 px) files to the 'resources' folder 
npm install capacitor-resources -g
capacitor-resources -p android

# last, build or debug in AS
