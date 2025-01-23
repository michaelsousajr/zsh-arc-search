# Arc browser search function in Zsh
arc() {
   if [[ $# -eq 0 ]]; then
       open -a Arc
       return
   fi
   search_query="$@"
   encoded_query=$(python3 -c "import urllib.parse; print(urllib.parse.quote('''$search_query'''))")
   open -a Arc "https://www.google.com/search?q=$encoded_query"
}

# Uppercase alias
ARC() {
   arc "$@"
}

# Title case alias 
Arc() {
   arc "$@"
}

# Add completion
_arc() {
   _arguments '*:search term'
}
compdef _arc arc
compdef _arc ARC
compdef _arc Arc
