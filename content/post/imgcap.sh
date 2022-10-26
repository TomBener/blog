#!/bin/zsh
# Convert general Markdown figure to Hugo shortcodes to render figures with captions

sed -i '' -E 's/!\[(.+)\]\((https.*)\)/{{< imgcap title=\"\1\" src=\"\2\" >}}/g' *.md
