define-command encapsul8-highlight-pair -hidden %{
    execute-keys "<a-S>"
}

define-command encapsul8-resolve-char-alias -hidden -params 2 %{
    set-option window %arg{2} %sh{
        case $1 in
            $kak_opt_encapsul8_mapping_alias_parentheses) echo '(' ;;
            $kak_opt_encapsul8_mapping_alias_square_brackets) echo '[' ;;
            $kak_opt_encapsul8_mapping_alias_braces) echo $kak_opt_encapsul8_opt_brace_rev ;;
            $kak_opt_encapsul8_mapping_alias_angle_brackets) echo '<lt>' ;;
            $kak_opt_encapsul8_mapping_alias_single_quote) echo "'" ;;
            $kak_opt_encapsul8_mapping_alias_double_quote) echo '"' ;;
            $kak_opt_encapsul8_mapping_alias_grave) echo '`' ;;
            *) echo "$1" ;;
        esac
    }
}
