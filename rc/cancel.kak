define-command encapsul8-check-cancel-with-user-position-restore -hidden -params 1 %{
    try %{
        evaluate-commands %sh{
            [[ $1 != $kak_opt_encapsul8_mapping_cancel ]] && echo nop || echo fail
        }
    } catch %{
        encapsul8-position-restore-user
        fail %val{error}
    }
}

