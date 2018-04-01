{ config, lib, pkgs, ... }:

with lib;

let
  is64bit = pkgs.stdenv.is64bit;

  cfg = config.boot.loader.raspberryPiUboot;

  uboot = 
    if cfg.version == 2 then 
      if is64bit then
        throw ("Raspberry Pi 2 does not support 64bit")
      else
        pkgs.ubootRaspberryPi2
    else if cfg.version == 3 then
      if is64bit then
        pkgs.ubootRaspberryPi3_64bit
      else
        pkgs.ubootRaspberryPi3_32bit
    else
      throw ("raspberrypi-uboot: unknown version: " ++ cfg.version);
   
  configtxt = 
    pkgs.writeText "config.txt" (if is64bit then
      ''
        kernel=u-boot-rpi.bin

        # Boot in 64-bit mode.
        arm_control=0x200

        # U-Boot used to need this to work, regardless of whether UART is actually used or not.
        # TODO: check when/if this can be removed.
        enable_uart=1

        # Prevent the firmware from smashing the framebuffer setup done by the mainline kernel
        # when attempting to show low-voltage or overtemperature warnings.
        avoid_warnings=1
      ''
    else
      ''
        # Prevent the firmware from smashing the framebuffer setup done by the mainline kernel
        # when attempting to show low-voltage or overtemperature warnings.
        avoid_warnings=1

        [pi2]
        kernel=u-boot-rpi.bin

        [pi3]
        kernel=u-boot-rpi.bin

        # U-Boot used to need this to work, regardless of whether UART is actually used or not.
        # TODO: check when/if this can be removed.
        enable_uart=1
      '');

  extlinuxconfbuilder =
    import ../generic-extlinux-compatible/extlinux-conf-builder.nix {
      inherit pkgs;
    };

  builder = pkgs.substituteAll {
    src = ./builder.sh;
    isExecutable = true;
    inherit (pkgs) bash;
    path = [pkgs.coreutils pkgs.gnused pkgs.gnugrep];
    firmware = pkgs.raspberrypifw;
    inherit uboot;
    inherit configtxt;
    inherit extlinuxconfbuilder;
    version = cfg.version;
  };

  platform = pkgs.stdenv.platform;

  blCfg = config.boot.loader;
  timeoutStr = if blCfg.timeout == null then "-1" else toString blCfg.timeout;

in

{
  options = {

    boot.loader.raspberryPiUboot.enable = mkOption {
      default = false;
      type = types.bool;
      description = ''
        Whether to create uboot compatible raspberry pi bootloader in
        <literal>/boot</literal>.
      '';
    };

    boot.loader.raspberryPiUboot.version = mkOption {
      default = 3;
      type = types.enum [ 2 3 ];
      description = ''
      '';
    };

    boot.loader.raspberryPiUboot.configurationLimit = mkOption {
      default = 20;
      example = 10;
      type = types.int;
      description = ''
        Maximum number of configurations in the boot menu.
      '';
    };


  };

  config = mkIf config.boot.loader.raspberryPiUboot.enable {
    system.build.installBootLoader = "${builder} -g ${toString cfg.configurationLimit} -t ${timeoutStr} -c";
    system.boot.loader.id = "raspberrypi-uboot";
    system.boot.loader.kernelFile = platform.kernelTarget;
  };
}
