#!/bin/bash

# append the path since when we call a script from processing we don't have a full path

export PATH=/Library/Frameworks/Python.framework/Versions/3.3/bin:/usr/local/bin:/Library/Frameworks/Python.framework/Versions/2.7/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/opt/X11/bin:$PATH;

# echo $PATH;

casperjs nameFinder.js "\"$1\""


