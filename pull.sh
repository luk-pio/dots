#!/usr/bin/env bash
set -euo pipefail

sudo ansible-pull -U https://github.com/luk-pio/dots.git -C main -t core home
