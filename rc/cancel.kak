define-command wrapify-check-cancel-with-user-position-restore -hidden -params 1 %{
    try %{
        evaluate-commands %sh{
            [[ $1 != $kak_opt_wrapify_mapping_cancel ]] && echo nop || echo fail
        }
    } catch %{
        wrapify-position-restore-user
        fail %val{error}
    }
}

