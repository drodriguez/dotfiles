function git__translate_argv
  for arg in $argv
    if begin
        # is $arg a number, and small enough to be an index of $c?
        echo $arg | egrep '^[0-9]+$' >/dev/null ^&1
        and [ $arg -le (count $c) ]
      end
        echo "$c[$arg]"
    
    # is $arg a fish array slice?
    # TODO: bounds checking here maybe? It's obnoxiusly long-winded
    else if echo $arg | egrep '^[0-9]+\.\.[0-9]+$' >/dev/null ^&1
      for subarg in $c[$arg]
        echo "$subarg"
      end
    else
      printf "%s\n" $arg
    end
  end
end
