# Show installation environment variables
gum log --level info "Installation Environment:"

env | grep -E "^(USER|HOME|HARPOCRATES_PATH)=" | sort | while IFS= read -r var; do
  gum log --level info "  $var"
done
