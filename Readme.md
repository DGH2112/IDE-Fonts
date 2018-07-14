DGH IDE Fonts
=============

Author:   David Hoyle

Version:  1.0

Date:     14 Jul 2018

Web Page: http://www.davidghoyle.co.uk/WordPress/?page_id=1960

## Overview

The purpose of this RAD Studio IDE expert is to change the default IDE fonts
in a selected number of windows.

For me, as I get older, the 8 and 9 point fonts used in the IDE are too small
(specially on higher resolution screens) and I would rather have a 10 point
font in Tahoma.

Unfortunately the IDE does not provide for this so hence this expert.

## Use

Its use is simple. On first run, just after the IDE becomes visible, you will
be shown a dialogue listing all the IDE windows found as shown below.

Select the windows you want to update paying special attention to their names
and class types as any forms on show in the form designer will also show and
you do NOT want to update those forms (at least I don't think you want to).
Then select the Font Name and Size and whether you want to force any components
in the window to adhere to the form's font and the press OK. Messages will
appear in the message window showing you which forms have been updated.

When you run the IDE on subsequent occasions the windows you selected will be
updated automatically on start-up without prompting.

If you want to manually run this at a later point, then select the IDE Fonts
menu item from the Help | Help Wizards menu.

## Current Limitations

Current this expert only runs once at start-up so any new windows created after
this point will not be adjusted however you can manually run the expert as described above.

## Binaries

You can download a binary of this project if you don't want to compile it
yourself from the web page above.