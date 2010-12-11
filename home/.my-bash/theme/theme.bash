#! /bin/bash

# SCM_THEME_PROMPT_DIRTY=" ${red}✗"
# SCM_THEME_PROMPT_CLEAN=" ${bold_green}✓"
# SCM_THEME_PROMPT_PREFIX=" ${green}|"
# SCM_THEME_PROMPT_SUFFIX="${green}|"


PROMPT="\[${bold_blue}\]\$(scm_char)\[${green}\]\$(scm_prompt_info)\[${blue}\]\$(rvm_version_prompt)\[${reset_color}\] \h:\W \u\$ "
