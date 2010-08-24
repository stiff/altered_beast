#!/bin/bash

YUI="java -jar misc/yuicompressor.jar"

CSS_PATH="public/stylesheets/"
JS_PATH="public/javascripts/"
TEMP="temporary/"

echo "Minifying Stylesheets..."

rm -rf $TEMP
mkdir -p $TEMP/$CSS_PATH
rm -f $CSS_PATH/all.css

find $CSS_PATH -name *.css -exec ${YUI} {} -o $TEMP/{} \;

rm -rf $CSS_PATH/*
cp $TEMP/$CSS_PATH/* $CSS_PATH

echo "Minifying Javascripts..."

rm -rf $TEMP
mkdir -p $TEMP/$JS_PATH
rm -f $JS_PATH/beast.js

find $JS_PATH -name *.js -exec ${YUI} {} -o $TEMP/{} \;

rm -rf $JS_PATH/*
cp $TEMP/$JS_PATH/* $JS_PATH

