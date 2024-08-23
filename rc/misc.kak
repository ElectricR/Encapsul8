define-command encapsul8-highlight-wrapping -hidden %{
    execute-keys "<a-S>"
}

define-command encapsul8-resolve-char-hotkey -hidden -params 2 %{
    set-option window %arg{2} %sh{
        case $1 in
            $kak_opt_encapsul8_mapping_match_parentheses) echo '(' ;;
            $kak_opt_encapsul8_mapping_match_square_brackets) echo '[' ;;
            $kak_opt_encapsul8_mapping_match_braces) echo $kak_opt_encapsul8_opt_brace_rev ;;
            $kak_opt_encapsul8_mapping_match_angle_brackets) echo '<lt>' ;;
            $kak_opt_encapsul8_mapping_match_single_quote) echo "'" ;;
            $kak_opt_encapsul8_mapping_match_double_quote) echo '"' ;;
            $kak_opt_encapsul8_mapping_match_grave) echo '`' ;;
            *) echo "$1" ;;
        esac
    }
}
