{pkgs, ...}: {
  programs.mpv = {
    enable = true;
    config = {
      autocreate-playlist = "filter";
      keep-open = "always";
      loop-file = "inf";
      osd-font-size = 14;
    };
    bindings = {
      h = "playlist-prev";
      l = "playlist-next";
      "f" = ''show-text "''${osd-ass-cc/0}{\\an8}''${filename}"'';
      "Ctrl+x" = "script-binding delete-current-file";
    };
  };

  xdg.configFile."mpv/scripts/delete-current-file.lua".text = ''
    local mp = require "mp"

    mp.add_key_binding(nil, "delete-current-file", function()
      local path = mp.get_property("path")
      if not path or path:match("^%a[%w+.-]*://") then
        mp.osd_message("Cannot delete a non-local file", 3)
        return
      end

      local confirmation = mp.command_native({
        name = "subprocess",
        playback_only = false,
        args = {
          "${pkgs.zenity}/bin/zenity",
          "--question",
          "--title=Delete current file?",
          "--text=Delete this file?\n" .. path,
        },
      })
      if not confirmation or confirmation.status ~= 0 then
        return
      end

      local index = mp.get_property_number("playlist-pos", 0)
      local ok, err = os.remove(path)
      if not ok then
        mp.osd_message("Could not delete " .. path .. ": " .. (err or "unknown error"), 5)
        return
      end

      mp.commandv("playlist-remove", tostring(index))
      mp.osd_message("Deleted " .. path, 3)
    end)
  '';
}
