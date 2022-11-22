#!/bin/bash

webapp_host=""
webapp_path="/opt/webapp/" # 结尾的/一定要保留

if [[ ! -z $webapp_host ]]; then
    webapp_host="${webapp_host}:"
fi

git pull && \
    yarn install && \
    yarn build && \
    rsync -varPz --delete dist/ $webapp_host$webapp_path
