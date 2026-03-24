convert_to_shell_name = $(shell echo "$(1)" | tr 'A-Z' 'a-z' | tr -c 'a-z' '_')
