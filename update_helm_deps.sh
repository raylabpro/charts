#!/usr/bin/env bash

for chartDir in `find ./riftbit -type d -maxdepth 1`; do helm dependency update "$chartDir"; done