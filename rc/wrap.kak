# Code to create wrapping
# For example:
#     Some |pretty| text -> Some |(pretty)| text

define-command encapsul8-wrap-add-pair -hidden -params 2 %{
    execute-keys "i%arg{1}<esc>a%arg{2}<esc>"
    execute-keys "<a-;>H<a-;>"
}

define-command encapsul8-wrap-add-pair-based-on -hidden -params 1 %{
    evaluate-commands %sh{
        case $1 in
            '('|')')       echo encapsul8-wrap-add-pair '(' ')' ;;
            "{"|"}")       echo encapsul8-wrap-add-pair '{' '}' ;;
            '<lt>'|'<gt>') echo encapsul8-wrap-add-pair '<lt>' '<gt>' ;;
            '['|']')       echo encapsul8-wrap-add-pair '[' ']' ;;
            '"')           echo encapsul8-wrap-add-pair '\"' '\"' ;;
            "'")           echo encapsul8-wrap-add-pair "\'" "\'" ;;
            *)             echo encapsul8-wrap-add-pair "$1" "$1" ;;

        esac
    }
}

declare-option -hidden str encapsul8_opt_wrap_resolve_char_hotkey
define-command encapsul8-wrap-exec -hidden %{
    encapsul8-info action_wrap
    on-key %{
        encapsul8-check-cancel-with-user-position-restore %val{key}
        encapsul8-resolve-char-hotkey %val{key} encapsul8_opt_wrap_resolve_char_hotkey
        encapsul8-wrap-add-pair-based-on %opt{encapsul8_opt_wrap_resolve_char_hotkey}
        encapsul8-undo-save
    }
}

define-command encapsul8-wrap -docstring 'Wrap the current selection with a chosen character' %{
    encapsul8-position-save-user
    encapsul8-wrap-exec
}
