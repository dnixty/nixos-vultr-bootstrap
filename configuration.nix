{ config, pkgs, ...}:

{
  imports = [
    ./hardware-configuration.nix
  ];

  boot = {
    kernel = {
      sysctl."vm.overcommit_memory" = "1";
    };

    loader = {
      grub.device = "/dev/vda";
      grub.enable = true;
      grub.version = 2;
    };
  };

  environment = {
    systemPackages = with pkgs; [
      curl
      gcc
      git
      nix-repl
      tmux
      vim
      wget
    ];

    variables = {
      EDITOR = "vim";
    };
  };

  i18n = {
    defaultLocale = "en_GB.UTF-8";
  };

  networking = {
    hostName = "njord";
  };

  nixpkgs.config = {
    allowBroken = false;
    allowUnfree = false;
  };

  programs = {
    bash = {
      enableCompletion = true;
    };

    ssh = {
      startAgent = true;
    };
  };

  services = {
    openssh = {
      enable = true;
      permitRootLogin = "prohibit-password";
    };
  };

  time.timeZone = "Europe/Amsterdam";

  users = {
    extraUsers = {
      dnixty = {
        extraGroups = [ "wheel" ];
        isNormalUser = true;
        openssh.authorizedKeys.keys = with import ./ssh-keys.nix; [ heimdall ];
      };

      root = {
        openssh.authorizedKeys.keys = with import ./ssh-keys.nix; [ heimdall ];
      };
    };
  };

  system.stateVersion = "19.09";
}
