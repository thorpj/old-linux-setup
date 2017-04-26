#!/bin/bash

askyesno ()
#Ask if user wishes to continue with given action. Can set default to yes or no

clone_repos
{
    repo_list=$'\n' read -d '' -r -a lines < "$loc_repo/repo_clone_list.txt"
    for repo_and_loc in "${lines[@]}"; do
        if [[ "${repo_and_loc:0:1}" == "#" ]] || [[ "${file:0:1}" == "" ]; then
            continue
        else
            repo=$(echo "$repo_and_loc" | cut -f1 -d ' ')
            loc=$(echo "$repo_and_loc" | cut -f2 -d ' ')
            if [ "$loc" = "git" ]; then
                git clone "git@github.com:$github_user/${repo}.git" "$loc_git/$repo"
            else
                git clone "git@github.com:$github_user/${repo}.git" "$loc_unigit/$repo"
            fi
        fi
    done
}

main ()
{
    clone_repos
}
main
