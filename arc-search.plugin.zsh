# arc-search.plugin.zsh

# URL encode function using built-in tools
url_encode() {
    local string="$1"
    local encoded=""
    local pos c o

    for ((pos=0; pos < ${#string}; pos++)); do
        c=${string:$pos:1}
        case $c in
            [-_.~a-zA-Z0-9])
                encoded+="$c"
                ;;
            *)
                printf -v o '%%%02x' "'$c"
                encoded+="${o}"
                ;;
        esac
    done
    echo "${encoded}"
}

# Arc browser function
arc() {
    if [[ $# -eq 0 ]]; then
        open -a Arc
        return
    fi
    search_query="$@"
    encoded_query=$(url_encode "$search_query")
    open -a Arc "https://www.google.com/search?q=$encoded_query"
}

# Case variants
ARC() { arc "$@" }
Arc() { arc "$@" }

# Add completion only if zsh completion system is available
if [[ -n "$ZSH_VERSION" ]] && which compdef >/dev/null 2>&1; then
    _arc() {
        _arguments '*:search term'
    }
    compdef _arc arc
    compdef _arc ARC
    compdef _arc Arc
fi
