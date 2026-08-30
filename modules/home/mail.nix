{ config, pkgs, ... }:
{
  accounts = {
    email = {
      accounts = {
        execvy = {
          primary = true;
          realName = "Eval Exec";
          address = "execvy@gmail.com";
          userName = "execvy@gmail.com";
          flavor = "gmail.com";
          folders = {
            inbox = "Inbox";
            drafts = "Drafts";
            sent = "Sent";
            trash = "Trash";
          };
          gpg = {
            key = "4B453CE70F2646044171BACE0F0272C0D3AC91F7";
          };
          passwordCommand = "${pkgs.coreutils}/bin/cat ${config.home.homeDirectory}/pass/gapp.txt";
          imap = {
            host = "imap.gmail.com";
            port = 993;
            tls = {
              enable = true;
            };
          };
          imapnotify = {
            enable = true;
            boxes = [ "INBOX" ];
            extraArgs = [
              "-wait 1"
              "-log-level debug"
            ];
            extraConfig = {
              enableIDCommand = true;
            };
            onNotify = ''
              ${pkgs.unstable.isync}/bin/mbsync --verbose --new execvy:INBOX
            '';
            onNotifyPost = ''
              ${pkgs.libnotify}/bin/notify-send 'goimapnotify received new emails'
              ${config.home.homeDirectory}/Projects/github.com/emacs-mirror/build/bin/emacsclient -e "
              (progn
                (unless (boundp 'mu4e--server-process)
                  (mu4e t))
                (mu4e-update-index-nonlazy)
                (message \"imapnotify received new mail.\"))"
            '';
          };

          msmtp = {
            enable = true;
          };
          mu = {
            enable = false;
          };
        };
      };
    };
  };

  services = {
    imapnotify = {
      enable = true;
    };
    mbsync = {
      enable = false;
      verbose = true;
    };
  };

  programs = {
    msmtp = {
      enable = true;
    };
  };
}
