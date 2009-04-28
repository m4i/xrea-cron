#!/bin/sh

if [ -f ~/.bash_profile ]
then
    source ~/.bash_profile
fi

ruby `dirname $0`/`basename $0 .sh`.rb
