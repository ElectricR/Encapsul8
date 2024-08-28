# Code to search for pairs in a text
# For example, select around parentheses here:
#     Some (text w|ith parentheses) -> Some |(text with parentheses)|
# Or here:
#     Some tex|t with [brackets] -> Some text with |[brackets]|

define-command encapsul8-search-in-direction -hidden -params 2 %{
    execute-keys "%arg{1}%arg{2}"
}

define-command encapsul8-search-with-kakoune -hidden -params 1 %{
    execute-keys "<a-a>%arg{1}"
}

declare-option -hidden str encapsul8_opt_brace '}'
declare-option -hidden str encapsul8_opt_brace_rev '{'
declare-option -hidden str encapsul8_opt_direction
declare-option -hidden str encapsul8_opt_search_resolve_char_hotkey
define-command encapsul8-search-pair -hidden -params 1 %{
    encapsul8-resolve-char-alias %arg{1} encapsul8_opt_search_resolve_char_hotkey
    try %sh{
        case $kak_opt_encapsul8_opt_search_resolve_char_hotkey in
            '('|')'|"{"|"}"|'<lt>'|'<gt>'|'['|']'|'`') echo encapsul8-search-with-kakoune "$kak_opt_encapsul8_opt_search_resolve_char_hotkey" ;;
            '"') echo encapsul8-search-with-kakoune '\"' ;;
            "'") echo encapsul8-search-with-kakoune "\'" ;;
            '.'|'*'|','|'?'|'^'|'|'|"<plus>"|'$') echo encapsul8-search-with-kakoune "c\\$1,\\$1<ret>" ;;
            '\') echo encapsul8-search-with-kakoune 'c\\\\,\\\\<ret>' ;;
            *) echo encapsul8-search-with-kakoune "c$1,$1<ret>" ;;
        esac
    } catch %{
        try %{
            evaluate-commands %sh{
                [[ "$1" == ')' ]] || [[ "$1" == "$kak_opt_encapsul8_opt_brace" ]] || [[ "$1" == ']' ]] || [[ "$1" == '<gt>' ]] || echo fail
            }
            set-option window encapsul8_opt_direction '<a-f>'
        } catch %{
            set-option window encapsul8_opt_direction 'f'
        }
        try %{
            encapsul8-search-in-direction %opt{encapsul8_opt_direction} %opt{encapsul8_opt_search_resolve_char_hotkey}
            encapsul8-search-pair %arg{1}
        } catch %{
            fail Could not find requested pair
        }
    }
    encapsul8-position-save-last-search
}
