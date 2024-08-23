# Simple wrapper around 'z' and 'Z' to
# save and restore selections

declare-option -hidden str encapsul8_position_save_user
declare-option -hidden str encapsul8_position_save_last_search

define-command encapsul8-position-save -hidden -params 1 %{
    evaluate-commands -save-regs '^' %{
        execute-keys -save-regs '/"|@:' "Z"
        echo
        set-option window "%arg{1}" "%val{reg_^}"
    }
}

define-command encapsul8-position-restore -hidden -params 1 %{
    evaluate-commands -save-regs '^' %{
        execute-keys -save-regs '' ":set-register caret %arg{1}<ret>"
        execute-keys -save-regs '/"|@:' "z"
        echo
    }
}

define-command encapsul8-position-save-user -hidden %{
    encapsul8-position-save 'encapsul8_position_save_user'
}

define-command encapsul8-position-restore-user -hidden %{
    encapsul8-position-restore "%opt{encapsul8_position_save_user}"
}

define-command encapsul8-position-save-last-search -hidden %{
    encapsul8-position-save 'encapsul8_position_save_last_search'
}

define-command encapsul8-position-restore-last-search -hidden %{
    encapsul8-position-restore "%opt{encapsul8_position_save_last_search}"
}

