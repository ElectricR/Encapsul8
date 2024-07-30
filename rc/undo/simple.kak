provide-module wrapify-undo-simple %{
    declare-option -hidden int wrapify_undo_history_id
    declare-option -hidden str wrapify_undo_saved_selections

    define-command wrapify-undo-save -hidden -override %{
        set-option window wrapify_undo_history_id %val{history_id}
        set-option window wrapify_undo_saved_selections "%opt{wrapify_position_save_user}"
    }

    define-command wrapify-undo -override %{
        evaluate-commands %sh{
            ( [[ $kak_opt_wrapify_undo_history_id == $kak_history_id ]] && echo nop ) || echo fail
        }
        execute-keys "u"
        wrapify-position-restore "%opt{wrapify_undo_saved_selections}"
    }

    define-command wrapify-redo -override %{
        execute-keys "U"
        try %{
            evaluate-commands %sh{
                ( [[ $kak_opt_wrapify_undo_history_id == $kak_history_id ]] && echo nop ) || echo fail
            }
            wrapify-position-restore "%opt{wrapify_undo_saved_selections}"
        } catch %{
            execute-keys "u"
            fail
        }
    }
}
