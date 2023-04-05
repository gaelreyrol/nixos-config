{ disko, ... }:

{
  disko.devices = {
    # Windows
    # Crucial_CT240M50 - 240Go ~ 223Gib
    disk.tower-sda = {
      device = "/dev/sda";
      type = "disk";
      format = "gpt";
      partitions = [
        {
          name = "boot";
          type = "partition";
          start = "0";
          end = "16M";
          fs-type = "ext4";
        }
        {
          name = "system";
          type = "partition";
          start = "16M";
          end = "100%";
          fs-type = "ntfs";
        }
      ];
    };
    # NixOS
    # Samsung SSD 860 - 500Go ~ 465GiB
    disk.tower-sdb = {
      device = "/dev/sdb";
      type = "disk";
      content = {
        type = "table";
        format = "gpt";
        partitions = [
          {
            name = "boot";
            type = "partition";
            start = "0";
            end = "1G";
            fs-type = "fat32";
            bootable = true;
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          }
          {
            name = "filesystem";
            type = "partition";
            start = "1G";
            end = "128G";
            part-type = "primary";
            bootable = true;
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/";
            };
          }
          {
            name = "filesystem";
            type = "partition";
            start = "128G";
            end = "100%";
            part-type = "primary";
            bootable = true;
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/home";
            };
          }
        ];
      };
    };
  };
}
