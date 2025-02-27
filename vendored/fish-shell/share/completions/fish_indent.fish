complete -c fish_indent -s h -l help -d 'Display help and exit'
complete -c fish_indent -s v -l version -d 'Display version and exit'
complete -c fish_indent -s i -l no-indent -d 'Do not indent output, only reformat into one job per line'
complete -c fish_indent -l only-indent -d 'Do not reformat, only indent lines'
complete -c fish_indent -l only-unindent -d 'Do not reformat, only unindent lines'
complete -c fish_indent -l ansi -d 'Colorize the output using ANSI escape sequences'
complete -c fish_indent -l html -d 'Output in HTML format'
complete -c fish_indent -s w -l write -d 'Write to file'
complete -c fish_indent -s d -l debug -x -d 'Enable debug at specified verbosity level'
complete -c fish_indent -s o -l debug-output -d "Where to direct debug output to" -rF
complete -c fish_indent -s D -l debug-stack-frames -x -d 'Specify how many stack frames to display in debug messages'
complete -c fish_indent -l dump-parse-tree -d 'Dump information about parsed statements to stderr'
