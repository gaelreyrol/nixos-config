{ disko, ... }:

{
  disko.devices = {
    # Kingfast F6M - 16Go ~ 14GiB
    disk.apu-sda = {
      device = "/dev/sda";
      type = "disk";
      content = {
        type = "table";
        format = "dos";
        partitions = [
          {
            name = "filesystem";
            type = "partition";
            start = "0";
            end = "100%";
            part-type = "primary";
            bootable = true;
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/";
            };
          }
        ];
      };
    };
  };
}
