define-command wrapify-check-cancel -hidden -params 1 %{
    evaluate-commands %sh{
        [[ $1 != $kak_opt_wrapify_mapping_cancel ]] && echo nop || echo fail
    }
}

define-command wrapify-check-cancel-with-user-position-restore -hidden -params 1 %{
    try %{
        wrapify-check-cancel %arg{1}
    } catch %{
        wrapify-position-restore-user
        fail %val{error}
    }
}

