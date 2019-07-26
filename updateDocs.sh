#!/bin/bash

# TODO: test for sourcekitten and jazzy, recommend installation 
sourcekitten doc --spm-module LoggingFormatAndPipe > LoggingFormatAndPipeSourceKitten.json
jazzy --clean --sourcekitten-sourcefile LoggingFormatAndPipeSourceKitten.json
rm LoggingFormatAndPipeSourceKitten.json
