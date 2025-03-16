# glab mr view
# if test $status = 0
#     return
# end

set -f target 'main'

if test (count $argv) -ne 2
    echo "creating for default branch"
    set -f target "$(git default-branch-name)"
else
    set -f target $argv[1]
end


# export TARGET="$(git default-branch-name)"
# export TARGET="new"
glab mr create --target-branch $target --fill --push --yes --remove-source-branch
