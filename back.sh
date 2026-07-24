#!/bin/bash
find /path -type f -maxdepth 1 -iname file.log -mtime +30 -exec rm -rf {} \;
