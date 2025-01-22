# Arc browser search function with incognito option
arc() {
   if [[ $# -eq 0 ]]; then
       open -a Arc
       return
   fi

   # Check for incognito flag
   if [[ $1 == "-i" ]]; then
       shift  # Remove the -i flag
       if [[ $# -eq 0 ]]; then
           open -a Arc --new-window --incognito
       else
           search_query="$@"
           encoded_query=$(python3 -c "import urllib.parse; print(urllib.parse.quote('''$search_query'''))")
           open -a Arc --new-window --incognito "https://www.google.com/search?q=$encoded_query"
       fi
   else
       search_query="$@"
       encoded_query=$(python3 -c "import urllib.parse; print(urllib.parse.quote('''$search_query'''))")
       open -a Arc "https://www.google.com/search?q=$encoded_query"
   fi
}

# Add completion
_arc() {
   _arguments \
       '-i[Open in incognito mode]' \
       '*:search term'
}
compdef _arc arc
