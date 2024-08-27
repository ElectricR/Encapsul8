declare-option -hidden str encapsul8_info_script_path %sh{ dirname "$kak_source" }
define-command encapsul8-info -hidden -params 1 %{
    try %{
        evaluate-commands %sh{
            $kak_opt_encapsul8_show_key_tips && echo nop || echo fail
        }
        info %sh{
            left_column_max_len=0

            function ack_left {
                [[ ${#1} -gt $left_column_max_len ]] && left_column_max_len=${#1}
            }

            function form_left {
                res=""
                for str in "$1" "$2" "$3"; do
                    if [ -n "$str" ]; then
                        if [ -n "$res" ]; then
                            res+=","
                        fi
                        res+="$str"
                    fi
                done
                echo "${res}:"
            }

            function declare_lefts {
                for opt in $@; do
                    if [[ -n ${!opt} ]]; then
                        export left_${opt}=`form_left "${!opt}"`
                    fi
                done
            }

            function print_all {
                for opt in $@; do
                    acc_l=`printf "left_%s" ${opt}`
                    acc_r=`printf "right_%s" ${opt}`
                    if [[ -n ${!acc_l} ]]; then
                        printf '%-*s %s\n' $left_column_max_len ${!acc_l} "${!acc_r}"
                    fi
                done
            }

            function translate_a_bit {
                case $1 in
                    '<lt>') echo '<' ;;
                    '<gt>') echo '>' ;;
                    *)      echo "$1"  ;;
                esac
            }
            kak_opt_encapsul8_iterate_current_search=`translate_a_bit "$kak_opt_encapsul8_iterate_current_search"`

            function filter_current_search {
                [[ $kak_opt_encapsul8_iterate_current_search != $1 ]] && echo $1
            }

            right_kak_opt_encapsul8_mapping_wrap_shortcut="create wrapping"
            right_kak_opt_encapsul8_mapping_cancel="cancel"
            right_kak_opt_encapsul8_mapping_action_select_inner="select inside the wrapping"
            right_kak_opt_encapsul8_mapping_action_select_outer="select with the wrapping"
            right_kak_opt_encapsul8_mapping_action_delete="delete the wrapping"
            right_kak_opt_encapsul8_mapping_action_replace="enter dedicated replace mode"
            right_kak_opt_encapsul8_mapping_action_wrap_around_shortcut="wrap the wrapping"
            right_kak_opt_encapsul8_mapping_action_wrap_within_shortcut="wrap the contents"
            right_kak_opt_encapsul8_iterate_current_search="search again"

            function action {
                left_1=`form_left "$kak_opt_encapsul8_mapping_match_parentheses"     '(' ')'`; right_1="find paretheses"; ack_left $left_1
                left_2=`form_left "$kak_opt_encapsul8_mapping_match_braces"          '{' '}'`; right_2="find curly braces"; ack_left $left_2
                left_3=`form_left "$kak_opt_encapsul8_mapping_match_square_brackets" '[' ']'`; right_3="find square brackets"; ack_left $left_3
                left_4=`form_left "$kak_opt_encapsul8_mapping_match_angle_brackets"  '<' '>'`; right_4="find angle brackets"; ack_left $left_4
                left_5=`form_left "$kak_opt_encapsul8_mapping_match_double_quote"    '"'`;     right_5="find double quotes"; ack_left $left_5
                left_6=`form_left "$kak_opt_encapsul8_mapping_match_single_quote"    "'"`;     right_6="find single quotes"; ack_left $left_6
                left_7=`form_left "$kak_opt_encapsul8_mapping_match_grave"           '\`'`;    right_7="find grave accents"; ack_left $left_7
                declare_lefts \
                    "kak_opt_encapsul8_mapping_wrap_shortcut" \
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
                    "kak_opt_encapsul8_mapping_wrap_shortcut" \
                    "100" \
                    "kak_opt_encapsul8_mapping_cancel"
            }


            function action_switch {
                left_1=`form_left "$(filter_current_search $kak_opt_encapsul8_mapping_match_parentheses)" "$(filter_current_search '(')" "$(filter_current_search ')')"`; right_1="replace with paretheses"; ack_left $left_1
                left_2=`form_left "$(filter_current_search $kak_opt_encapsul8_mapping_match_braces)" "$(filter_current_search '{')" "$(filter_current_search '}')"`; right_2="replace with curly braces"; ack_left $left_2
                left_3=`form_left "$(filter_current_search $kak_opt_encapsul8_mapping_match_square_brackets)" "$(filter_current_search '[')" "$(filter_current_search ']')"`; right_3="replace with square brackets"; ack_left $left_3
                left_4=`form_left "$(filter_current_search $kak_opt_encapsul8_mapping_match_angle_brackets)" "$(filter_current_search '<')" "$(filter_current_search '>')"`; right_4="replace with angle brackets"; ack_left $left_4
                left_5=`form_left "$(filter_current_search $kak_opt_encapsul8_mapping_match_double_quote)" $(filter_current_search '"')`; right_5="replace with double quotes"; ack_left $left_5
                left_6=`form_left "$(filter_current_search $kak_opt_encapsul8_mapping_match_single_quote)" $(filter_current_search "'")`; right_6="replace with single quotes"; ack_left $left_6
                left_7=`form_left "$(filter_current_search $kak_opt_encapsul8_mapping_match_grave)" $(filter_current_search '\`')`; right_7="replace with grave accents"; ack_left $left_7
                left_100=`form_left '<char>'`; right_100="replace with the given char"; ack_left $left_100
                declare_lefts \
                    "kak_opt_encapsul8_mapping_action_select_inner" \
                    "kak_opt_encapsul8_mapping_action_select_outer" \
                    "kak_opt_encapsul8_mapping_action_delete" \
                    "kak_opt_encapsul8_mapping_action_replace" \
                    "kak_opt_encapsul8_mapping_action_wrap_around_shortcut" \
                    "kak_opt_encapsul8_mapping_action_wrap_within_shortcut" \
                    "kak_opt_encapsul8_mapping_cancel"
                case "$kak_opt_encapsul8_iterate_current_search" in
                    "$kak_opt_encapsul8_mapping_action_select_inner"| \
                    "$kak_opt_encapsul8_mapping_action_select_outer"| \
                    "$kak_opt_encapsul8_mapping_action_delete"| \
                    "$kak_opt_encapsul8_mapping_action_replace"| \
                    "$kak_opt_encapsul8_mapping_action_wrap_around_shortcut"| \
                    "$kak_opt_encapsul8_mapping_action_wrap_within_shortcut") ;;
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
                    "kak_opt_encapsul8_mapping_action_wrap_around_shortcut" \
                    "kak_opt_encapsul8_mapping_action_wrap_within_shortcut" \
                    "100" \
                    "kak_opt_encapsul8_mapping_cancel"
            }

            function action_replace {
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

            function action_wrap {
                left_1=`form_left "$kak_opt_encapsul8_mapping_match_parentheses"     '(' ')'`; right_1="wrap with paretheses"; ack_left $left_1
                left_2=`form_left "$kak_opt_encapsul8_mapping_match_braces"          '{' '}'`; right_2="wrap with curly braces"; ack_left $left_2
                left_3=`form_left "$kak_opt_encapsul8_mapping_match_square_brackets" '[' ']'`; right_3="wrap with square brackets"; ack_left $left_3
                left_4=`form_left "$kak_opt_encapsul8_mapping_match_angle_brackets"  '<' '>'`; right_4="wrap with angle brackets"; ack_left $left_4
                left_5=`form_left "$kak_opt_encapsul8_mapping_match_double_quote"    '"'`;     right_5="wrap with double quotes"; ack_left $left_5
                left_6=`form_left "$kak_opt_encapsul8_mapping_match_single_quote"    "'"`;     right_6="wrap with single quotes"; ack_left $left_6
                left_7=`form_left "$kak_opt_encapsul8_mapping_match_grave"           '\`'`;    right_7="wrap with grave accents"; ack_left $left_7
                left_100=`form_left '<char>'`; right_100="wrap with the given char"; ack_left $left_100
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
