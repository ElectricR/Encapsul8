# Code to create wrapping
# For example:
#     Some |pretty| text -> Some |(pretty)| text

define-command wrapify-wrap-add-pair -hidden -params 2 %{
    execute-keys "i%arg{1}<esc>a%arg{2}<esc>"
    execute-keys "<a-;>H<a-;>"
}

define-command wrapify-wrap-add-pair-based-on -hidden -params 1 %{
    evaluate-commands %sh{
        case $1 in
            '('|')')       echo wrapify-wrap-add-pair '(' ')' ;;
            "{"|"}")       echo wrapify-wrap-add-pair '{' '}' ;;
            '<lt>'|'<gt>') echo wrapify-wrap-add-pair '<lt>' '<gt>' ;;
            '['|']')       echo wrapify-wrap-add-pair '[' ']' ;;
            '"')           echo wrapify-wrap-add-pair '\"' '\"' ;;
            "'")           echo wrapify-wrap-add-pair "\'" "\'" ;;
            *)             echo wrapify-wrap-add-pair "$1" "$1" ;;
        esac
    }
}

define-command wrapify-wrap %{
    on-key %{
        wrapify-check-cancel %val{key}
        wrapify-position-save-user
        wrapify-wrap-add-pair-based-on %val{key}
        wrapify-undo-save
    }
}
