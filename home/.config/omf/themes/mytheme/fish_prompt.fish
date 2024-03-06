function fish_prompt
  set -l last_command_status $status
  set -l cwd

  if test "$theme_short_path" = 'yes'
    set cwd (basename (prompt_pwd))
  else
    set cwd (prompt_pwd)
  end

  set -l fish     "⋊>"
  set -l ahead    "↑"
  set -l behind   "↓"
  set -l diverged "⥄ "
  set -l dirty    "⨯"
  set -l none     "◦"

  set -l normal_color     (set_color normal)
  set -l success_color    (set_color $fish_pager_color_progress 2>/dev/null; or set_color cyan)
  set -l error_color      (set_color $fish_color_error 2>/dev/null; or set_color red --bold)
  set -l directory_color  (set_color $fish_color_quote 2>/dev/null; or set_color brown)
  set -l repository_color (set_color $fish_color_cwd 2>/dev/null; or set_color green)
  set -l python_color     (set_color -b blue white)

  if test $last_command_status -eq 0
    echo -n -s $success_color $fish $normal_color
  else
    echo -n -s $error_color $fish $normal_color
  end

  if git_is_repo
    if test "$theme_short_path" = 'yes'
      set root_folder (command git rev-parse --show-toplevel 2>/dev/null)
      set parent_root_folder (dirname $root_folder)
      set cwd (echo $PWD | sed -e "s|$parent_root_folder/||")

      echo -n -s " " $directory_color $cwd $normal_color
    else
      echo -n -s " " $directory_color $cwd $normal_color
    end

    echo -n -s " on " $repository_color (git_branch_name) $normal_color " "

    if git_is_touched
      echo -n -s $dirty
    else
      echo -n -s (git_ahead $ahead $behind $diverged $none)
    end
  else if hg_is_repo
    if test "$theme_short_path" = 'yes'
      set root_folder (command hg root 2> /dev/null)
      set parent_root_folder (dirname $root_folder)
      set cwd (echo $PWD | sed -e "s|$parent_root_folder/||")

      echo -n -s " " $directory_color $cwd $normal_color
    else
      echo -n -s " " $directory_color $cwd $normal_color
    end

    echo -n -s " on " $repository_color (hg_current_name) $normal_color " "

    if hg_is_touched
      echo -n -s $dirty
    end
  else
    echo -n -s " " $directory_color $cwd $normal_color
  end

  if set -q VIRTUAL_ENV
    echo -n -s " 🐍 " $python_color (basename $VIRTUAL_ENV) $normal_color
  end

  echo -n -s " "
end
