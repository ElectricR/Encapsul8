# Code to create surrounding
# For example:
#     Some |pretty| text -> Some |(pretty)| text

define-command encapsul8-surround-add-pair -hidden -params 2 %{
    execute-keys "i%arg{1}<esc>a%arg{2}<esc>"
    execute-keys "<a-;>H<a-;>"
}

define-command encapsul8-surround-add-pair-based-on -hidden -params 1 %{
    evaluate-commands %sh{
        case $1 in
            '('|')')       echo encapsul8-surround-add-pair '(' ')' ;;
            "{"|"}")       echo encapsul8-surround-add-pair '{' '}' ;;
            '<lt>'|'<gt>') echo encapsul8-surround-add-pair '<lt>' '<gt>' ;;
            '['|']')       echo encapsul8-surround-add-pair '[' ']' ;;
            '"')           echo encapsul8-surround-add-pair '\"' '\"' ;;
            "'")           echo encapsul8-surround-add-pair "\'" "\'" ;;
            *)             echo encapsul8-surround-add-pair "$1" "$1" ;;

        esac
    }
}

declare-option -hidden str encapsul8_opt_surround_resolve_char_hotkey
define-command encapsul8-surround-exec -hidden -params 1 %{
    encapsul8-info action_surround
    on-key %{
        encapsul8-check-cancel-with-user-position-restore %val{key}
        encapsul8-resolve-char-alias %val{key} encapsul8_opt_surround_resolve_char_hotkey
        encapsul8-surround-add-pair-based-on %opt{encapsul8_opt_surround_resolve_char_hotkey}
        encapsul8-undo-save
        %arg{1}
    }
}

define-command encapsul8-surround-exec-with-restore -hidden %{
    encapsul8-surround-exec encapsul8-position-restore-user
}

define-command encapsul8-surround-exec-without-restore -hidden %{
    encapsul8-surround-exec nop
}

define-command encapsul8-surround -docstring 'Wrap the current selection with a chosen character' %{
    encapsul8-position-save-user
    encapsul8-surround-exec-without-restore
}
