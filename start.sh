#!/bin/bash

# available placeholders
# <FROM> monday date of this week
# <TO> friday date of this week
# <EMAIL> email of user (set in profile.sh)

. ./profile.sh

DEFAULT_MESSAGE="$(cat "default-message.md")"
GENERATED="generated-$$.md"

print_start_title(){
 echo "------------------------------"
 echo "AB Generator"
 echo "------------------------------"
}

check_profile_params(){
    echo "The following params are set for this process: "
    echo "USER_EMAIL=$USER_EMAIL"
    echo "CLEANUP_OLD_FILES=$CLEANUP_OLD_FILES"
    echo "FORWARD_DAY_PADDING=$FORWARD_DAY_PADDING"
}

cleanup_old_files(){
    if [[ "$CLEANUP_OLD_FILES" == "true" ]]; then
        rm generated-*.md 2>/dev/null
    fi
}

set_placeholders(){
    cp default-message.md generated-$$.md

    weekday_index="$(date --date="+${FORWARD_DAY_PADDING} days" "+%u")"
    weekday_index=$((weekday_index - 1))

    monday_date="$(date --date="+${FORWARD_DAY_PADDING} days -${weekday_index} days" "+%d.%m.%Y")"

    friday_index=$((5 - weekday_index - 1))
    friday_date="$(date --date="+${FORWARD_DAY_PADDING} days +${friday_index} days" "+%d.%m.%Y")"

    sed -i "s|<FROM>|$monday_date|g" "$GENERATED"
    sed -i "s|<TO>|$friday_date|g" "$GENERATED"
    sed -i "s|<EMAIL>|$USER_EMAIL|g" "$GENERATED"
}

finish(){
    echo
    echo "Done"
    echo "Your message was saved as $GENERATED"
}

print_start_title
check_profile_params
cleanup_old_files
set_placeholders
finish
