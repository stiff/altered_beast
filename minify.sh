#!/bin/bash

YUI="java -jar misc/yuicompressor.jar"

CSS_PATH="public/stylesheets/"
TEMP="temporary/"

rm -rf $TEMP
mkdir -p $TEMP/$CSS_PATH
rm -f $CSS_PATH/all.css

find $CSS_PATH -name *.css -exec ${YUI} {} -o $TEMP/{} \;

rm -rf $CSS_PATH/*
cp $TEMP/$CSS_PATH/* $CSS_PATH
