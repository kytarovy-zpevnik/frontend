#!/bin/bash

lessc --compress ../less/screen.less > ../css/screen.css
dart2js --package-root=../packages --minify -o ../js/app.js ../main.dart