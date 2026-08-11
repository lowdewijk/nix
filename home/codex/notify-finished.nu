#!/usr/bin/env nu

# Codex passes the completed-turn event as JSON in the first argument.
def main [payload: string] {
  let event = try {
    $payload | from json
  } catch {
    {}
  }
  let message = (
    $event
    | get -o 'last-assistant-message'
    | default ($event | get -o last_assistant_message | default ($event | get -o message | default ($event | get -o summary | default 'Finished')))
    | into string
    | str replace -a "\n" ' '
    | str substring 0..499
  )

  ^/run/current-system/sw/bin/dbus-send --session --dest=org.freedesktop.Notifications --type=method_call /org/freedesktop/Notifications org.freedesktop.Notifications.Notify string:Codex uint32:0 string: string:Codex $"string:($message)" array:string: dict:string:variant: int32:-1
}
