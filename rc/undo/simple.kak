provide-module encapsul8-undo-simple %{
    declare-option -hidden int encapsul8_undo_history_id
    declare-option -hidden str encapsul8_undo_saved_selections

    define-command encapsul8-undo-save -hidden -override %{
        set-option window encapsul8_undo_history_id %val{history_id}
        set-option window encapsul8_undo_saved_selections "%opt{encapsul8_position_save_user}"
    }

    define-command encapsul8-undo -override -docstring 'Try to undo the last change, if it was made by Encapsul8 (simple version)' %{
        evaluate-commands %sh{
            ( [ $kak_opt_encapsul8_undo_history_id = $kak_history_id ] && echo nop ) || echo fail
        }
        execute-keys "u"
        encapsul8-position-restore "%opt{encapsul8_undo_saved_selections}"
    }

    define-command encapsul8-redo -override -docstring 'Try to redo the last change, if it was made by Encapsul8 (simple version)' %{
        execute-keys "U"
        try %{
            evaluate-commands %sh{
                ( [ $kak_opt_encapsul8_undo_history_id = $kak_history_id ] && echo nop ) || echo fail
            }
            encapsul8-position-restore "%opt{encapsul8_undo_saved_selections}"
        } catch %{
            execute-keys "u"
            fail
        }
    }
}
