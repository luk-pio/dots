#!/usr/bin/env bash
set -euo pipefail

sudo ansible-pull -U https://github.com/luk-pio/dots.git -C main -v -e @/home/l/Workspace/dots/vars.yml
