declare-option -hidden str encapsul8_info_script_path %sh{ dirname "$kak_source" }
define-command encapsul8-info -hidden -params 1 %{
    try %{
        evaluate-commands %sh{
            $kak_opt_encapsul8_show_key_tips && echo nop || echo fail
        }
        info %sh{
            left_column_max_len=0

            ack_left() {
                [ ${#1} -gt $left_column_max_len ] && left_column_max_len=${#1}
            }

            form_left() {
                res=""
                for str in "$1" "$2" "$3"; do
                    if [ -n "$str" ]; then
                        if [ -n "$res" ]; then
                            res="${res},"
                        fi
                        res="${res}${str}"
                    fi
                done
                echo "${res}:"
            }

            declare_lefts() {
                for opt in $@; do
                    eval "opt_exp=\$$opt"
                    if [ -n ${opt_exp} ]; then
                        export left_${opt}=`form_left "${opt_exp}"`
                    fi
                done
            }

            print_all() {
                for opt in $@; do
                    acc_l=`printf "left_%s" ${opt}`
                    acc_r=`printf "right_%s" ${opt}`
                    eval "acc_exp_r=\$$acc_r"
                    eval "acc_exp_l=\$$acc_l"

                    if [ "${acc_exp_l}" != ":" ] && [ -n "${acc_exp_r}" ]; then
                        printf '%-*s %s\n' $left_column_max_len ${acc_exp_l} "${acc_exp_r}"
                    fi
                done
            }

            translate_a_bit() {
                case $1 in
                    '<lt>') echo '<' ;;
                    '<gt>') echo '>' ;;
                    *)      echo "$1"  ;;
                esac
            }
            kak_opt_encapsul8_iterate_current_search=`translate_a_bit "$kak_opt_encapsul8_iterate_current_search"`

            filter_current_search() {
                [ $kak_opt_encapsul8_iterate_current_search != $1 ] && echo $1
            }

            right_kak_opt_encapsul8_mapping_surround_shortcut="create surrounding"
            right_kak_opt_encapsul8_mapping_cancel="cancel"
            right_kak_opt_encapsul8_mapping_action_select_inner="select inside the surrounding"
            right_kak_opt_encapsul8_mapping_action_select_outer="select with the surrounding"
            right_kak_opt_encapsul8_mapping_action_delete="delete the surrounding"
            right_kak_opt_encapsul8_mapping_action_replace="enter dedicated replace mode"
            right_kak_opt_encapsul8_mapping_action_surround_around_shortcut="surround the surrounding"
            right_kak_opt_encapsul8_mapping_action_surround_within_shortcut="surround the contents"
            right_kak_opt_encapsul8_iterate_current_search="search again"

            action() {
                left_1=`form_left "$kak_opt_encapsul8_mapping_alias_parentheses"     '(' ')'`; right_1="find paretheses"; ack_left $left_1
                left_2=`form_left "$kak_opt_encapsul8_mapping_alias_braces"          '{' '}'`; right_2="find curly braces"; ack_left $left_2
                left_3=`form_left "$kak_opt_encapsul8_mapping_alias_square_brackets" '[' ']'`; right_3="find square brackets"; ack_left $left_3
                left_4=`form_left "$kak_opt_encapsul8_mapping_alias_angle_brackets"  '<' '>'`; right_4="find angle brackets"; ack_left $left_4
                left_5=`form_left "$kak_opt_encapsul8_mapping_alias_double_quote"    '"'`;     right_5="find double quotes"; ack_left $left_5
                left_6=`form_left "$kak_opt_encapsul8_mapping_alias_single_quote"    "'"`;     right_6="find single quotes"; ack_left $left_6
                left_7=`form_left "$kak_opt_encapsul8_mapping_alias_grave"           '\`'`;    right_7="find grave accents"; ack_left $left_7
                declare_lefts \
                    "kak_opt_encapsul8_mapping_surround_shortcut" \
                    "kak_opt_encapsul8_mapping_cancel" \

                left_100=`form_left '<char>'`; right_100="find the given char"; ack_left $left_100

                print_all \
                    "1" \
                    "2" \
                    "3" \
                    "4" \
                    "5" \
                    "6" \
                    "7" \
                    "kak_opt_encapsul8_mapping_surround_shortcut" \
                    "100" \
                    "kak_opt_encapsul8_mapping_cancel"
            }


            action_switch() {
                left_1=`form_left "$(filter_current_search $kak_opt_encapsul8_mapping_alias_parentheses)" "$(filter_current_search '(')" "$(filter_current_search ')')"`; right_1="replace with paretheses"; ack_left $left_1
                left_2=`form_left "$(filter_current_search $kak_opt_encapsul8_mapping_alias_braces)" "$(filter_current_search '{')" "$(filter_current_search '}')"`; right_2="replace with curly braces"; ack_left $left_2
                left_3=`form_left "$(filter_current_search $kak_opt_encapsul8_mapping_alias_square_brackets)" "$(filter_current_search '[')" "$(filter_current_search ']')"`; right_3="replace with square brackets"; ack_left $left_3
                left_4=`form_left "$(filter_current_search $kak_opt_encapsul8_mapping_alias_angle_brackets)" "$(filter_current_search '<')" "$(filter_current_search '>')"`; right_4="replace with angle brackets"; ack_left $left_4
                left_5=`form_left "$(filter_current_search $kak_opt_encapsul8_mapping_alias_double_quote)" $(filter_current_search '"')`; right_5="replace with double quotes"; ack_left $left_5
                left_6=`form_left "$(filter_current_search $kak_opt_encapsul8_mapping_alias_single_quote)" $(filter_current_search "'")`; right_6="replace with single quotes"; ack_left $left_6
                left_7=`form_left "$(filter_current_search $kak_opt_encapsul8_mapping_alias_grave)" $(filter_current_search '\`')`; right_7="replace with grave accents"; ack_left $left_7
                left_100=`form_left '<char>'`; right_100="replace with the given char"; ack_left $left_100
                declare_lefts \
                    "kak_opt_encapsul8_mapping_action_select_inner" \
                    "kak_opt_encapsul8_mapping_action_select_outer" \
                    "kak_opt_encapsul8_mapping_action_delete" \
                    "kak_opt_encapsul8_mapping_action_replace" \
                    "kak_opt_encapsul8_mapping_action_surround_around_shortcut" \
                    "kak_opt_encapsul8_mapping_action_surround_within_shortcut" \
                    "kak_opt_encapsul8_mapping_cancel"
                case "$kak_opt_encapsul8_iterate_current_search" in
                    "$kak_opt_encapsul8_mapping_action_select_inner"| \
                    "$kak_opt_encapsul8_mapping_action_select_outer"| \
                    "$kak_opt_encapsul8_mapping_action_delete"| \
                    "$kak_opt_encapsul8_mapping_action_replace"| \
                    "$kak_opt_encapsul8_mapping_action_surround_around_shortcut"| \
                    "$kak_opt_encapsul8_mapping_action_surround_within_shortcut") ;;
                    *) declare_lefts "kak_opt_encapsul8_iterate_current_search" ;;
                esac
                print_all \
                    "kak_opt_encapsul8_iterate_current_search" \
                    "1" \
                    "2" \
                    "3" \
                    "4" \
                    "5" \
                    "6" \
                    "7" \
                    "kak_opt_encapsul8_mapping_action_select_inner" \
                    "kak_opt_encapsul8_mapping_action_select_outer" \
                    "kak_opt_encapsul8_mapping_action_delete" \
                    "kak_opt_encapsul8_mapping_action_replace" \
                    "kak_opt_encapsul8_mapping_action_surround_around_shortcut" \
                    "kak_opt_encapsul8_mapping_action_surround_within_shortcut" \
                    "100" \
                    "kak_opt_encapsul8_mapping_cancel"
            }

            action_replace() {
                left_1=`form_left '(' ')'`; right_1="replace with paretheses"; ack_left $left_1
                left_2=`form_left '{' '}'`; right_2="replace with curly braces"; ack_left $left_2
                left_3=`form_left '[' ']'`; right_3="replace with square brackets"; ack_left $left_3
                left_4=`form_left '<' '>'`; right_4="replace with angle brackets"; ack_left $left_4
                left_100=`form_left '<char>'`; right_100="replace with the given char"; ack_left $left_100
                declare_lefts \
                    "kak_opt_encapsul8_mapping_cancel"

                print_all \
                    "1" \
                    "2" \
                    "3" \
                    "4" \
                    "100" \
                    "kak_opt_encapsul8_mapping_cancel"
            }

            action_surround() {
                left_1=`form_left "$kak_opt_encapsul8_mapping_alias_parentheses"     '(' ')'`; right_1="surround with paretheses"; ack_left $left_1
                left_2=`form_left "$kak_opt_encapsul8_mapping_alias_braces"          '{' '}'`; right_2="surround with curly braces"; ack_left $left_2
                left_3=`form_left "$kak_opt_encapsul8_mapping_alias_square_brackets" '[' ']'`; right_3="surround with square brackets"; ack_left $left_3
                left_4=`form_left "$kak_opt_encapsul8_mapping_alias_angle_brackets"  '<' '>'`; right_4="surround with angle brackets"; ack_left $left_4
                left_5=`form_left "$kak_opt_encapsul8_mapping_alias_double_quote"    '"'`;     right_5="surround with double quotes"; ack_left $left_5
                left_6=`form_left "$kak_opt_encapsul8_mapping_alias_single_quote"    "'"`;     right_6="surround with single quotes"; ack_left $left_6
                left_7=`form_left "$kak_opt_encapsul8_mapping_alias_grave"           '\`'`;    right_7="surround with grave accents"; ack_left $left_7
                left_100=`form_left '<char>'`; right_100="surround with the given char"; ack_left $left_100
                declare_lefts \
                    "kak_opt_encapsul8_mapping_cancel"

                print_all \
                    "1" \
                    "2" \
                    "3" \
                    "4" \
                    "5" \
                    "6" \
                    "7" \
                    "100" \
                    "kak_opt_encapsul8_mapping_cancel"
            }

            $1
        }
    }
}
