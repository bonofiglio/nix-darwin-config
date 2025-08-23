{ pkgs, lib, ... }:
let
  # We point directly to 'gnugrep' instead of 'grep'
  grep = lib.meta.getExe pkgs.gnugrep;
  flatpak = lib.meta.getExe pkgs.flatpak;
  # 1. Declare the Flatpaks you *want* on your system
  desiredFlatpaks = [
    "org.mozilla.firefox"
    # "com.discordapp.Discord" not available on arm64...
  ];
in
{
  system.activationScripts.flatpakManagement.text = ''
    # 2. Ensure the Flathub repo is added
    ${flatpak} remote-add --if-not-exists flathub \
      https://dl.flathub.org/repo/flathub.flatpakrepo

    # 3. Get currently installed Flatpaks
    installedFlatpaks=$(${flatpak} list --app --columns=application)

    # 4. Remove any Flatpaks that are NOT in the desired list
    for installed in $installedFlatpaks; do
      if ! echo ${toString desiredFlatpaks} | ${grep} -q $installed; then
        echo "Removing $installed because it's not in the desiredFlatpaks list."
        ${flatpak} uninstall -y --noninteractive $installed
      fi
    done

    # 5. Install or re-install the Flatpaks you DO want
    for app in ${toString desiredFlatpaks}; do
      echo "Ensuring $app is installed."
      ${flatpak} install -y flathub $app
    done

    # 6. Remove unused Flatpaks
    ${flatpak} uninstall --unused -y

    # 7. Update all installed Flatpaks
    ${flatpak} update -y
  '';
}
