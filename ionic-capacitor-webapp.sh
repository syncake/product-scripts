#!/bin/bash

# node v14 required
# capacitor installation
# url: https://capacitorjs.com/docs/getting-started

projectpath="./webapp"

# 包创建项目
makeProject () {
    npm init @capacitor/app $projectpath

    cd $projectpath
    npm i @capacitor/core
    npm i -D @capacitor/cli
}

# 手动创建，使用新项目或现有项目
makeProjectManual () {
    mkdir -p $projectpath && cd $projectpath
    npm init -y

    npm i @capacitor/core
    npm i -D @capacitor/cli

    npx cap init
}

makeProjectManual

# ANDROID
npm i @capacitor/android
npx cap add android

mkdir -p dist
echo "webapp" > dist/index.html
npx cap sync

exit 0

# OPTIONAL以下可选
##################
# ICON & SPLASH
## url: https://stackoverflow.com/questions/60549868/ionic-5-how-to-replace-default-icon-and-splash-screen-image-and-generate-resou
## comment: make sure directory resources exists and Add your icon.png (1024x1024 px) and splash.png (2732x2732 px) files to the 'resources' folder 
npm install capacitor-resources -g
capacitor-resources -p android