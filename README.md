# lowResourcesPowerShellAlert
Minimalistic Windows low resources monitoring script. Not perfect but most likely good enough for 99% of cases out there ;-)

## Motivation
Amazon Web Services (AWS) is not providing an out of the box solution for such simple thing as monitoring HDD, Memory and CPU usage. We have Monit for Linux but nothing simple enough for Windows. Prometheus is great but probably overkilling for a small startup.

## How to schedule
Task Scheduler | New Task: Name: lowResourcesAlert; Check “Run whether user is logged on or not” and “Do not store password” | Triggers | New Trigger: Begin the task: On a schedule; Settings: Daily; Recur every 1 day; Start now; repeat task every 5 minutes for a duration of 1 day; Enabled | OK | Actions | New | Start a program; Program/Script: powershell; Add arguments: -executionpolicy bypass -F c:\scripts\lowResourcesAlert.ps1 | OK

## Keep the history
Task Scheduler | Enable All Tasks History from the Actions Right pane 

## Too many alerts?
While you correct the issue: Task Scheduler | Right click the task | Disable

When the issue has been corrected: Task Scheduler | Right click the task | Enable 