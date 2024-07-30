# Code to search for pairs in a text
# For example, select around parentheses here:
#     Some (text w|ith parentheses) -> Some |(text with parentheses)|
# Or here:
#     Some tex|t with [brackets] -> Some text with |[brackets]|

define-command wrapify-search-in-direction -hidden -params 2 %{
    execute-keys "%arg{1}%arg{2}"
}

define-command wrapify-search-with-kakoune -hidden -params 1 %{
    execute-keys "<a-a>%arg{1}"
}

declare-option -hidden str wrapify_opt_brace '}'
declare-option -hidden str wrapify_opt_brace_rev '{'
declare-option -hidden str wrapify_opt_direction
define-command wrapify-search-pair -hidden -params 1 %{
    try %sh{
        case $1 in
            '('|')'|"{"|"}"|'<lt>'|'<gt>'|'['|']'|'`') echo wrapify-search-with-kakoune "$1" ;;
            '"') echo wrapify-search-with-kakoune '\"' ;;
            "'") echo wrapify-search-with-kakoune "\'" ;;
            '.'|'*'|','|'?'|'^'|'|'|"<plus>"|'$') echo wrapify-search-with-kakoune "c\\$1,\\$1<ret>" ;;
            '\') echo wrapify-search-with-kakoune 'c\\\\,\\\\<ret>' ;;
            *) echo wrapify-search-with-kakoune "c$1,$1<ret>" ;;
        esac
    } catch %{
        try %{
            evaluate-commands %sh{
                [[ "$1" == ')' ]] || [[ "$1" == "$kak_opt_wrapify_opt_brace" ]] || [[ "$1" == ']' ]] || [[ "$1" == '<gt>' ]] || echo fail
            }
            set-option window wrapify_opt_direction '<a-f>'
        } catch %{
            set-option window wrapify_opt_direction 'f'
        }
        try %{
            wrapify-search-in-direction %opt{wrapify_opt_direction} %arg{1}
            wrapify-search-pair %arg{1}
        } catch %{
            fail Could not find requested pair
        }
    }
    wrapify-position-save-last-search
}
