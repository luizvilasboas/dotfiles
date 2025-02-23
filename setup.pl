#!/usr/bin/perl
use strict;
use warnings;

use feature 'say';

use YAML::XS 'LoadFile';

sub remove_packages {
    my @packages = @_;
    if (@packages) {
        my $package_list = join( ' ', @packages );
        say "Removing packages: $package_list";
        system("sudo pacman -Rns --noconfirm $package_list");
    }
    else {
        say "No packages to remove.";
    }
}

sub install_packages {
    my @packages = @_;
    if (@packages) {
        my $package_list = join( ' ', @packages );
        say "Installing packages: $package_list";
        system("sudo pacman -Sy --needed --noconfirm $package_list");
    }
    else {
        say "No packages to install.";
    }
}

sub install_aur_packages {
    my @aur_packages = @_;
    if (@aur_packages) {
        my $aur_package_list = join( ' ', @aur_packages );
        say "Installing AUR packages: $aur_package_list";
        system("yay -Sy --needed --noconfirm $aur_package_list");
    }
    else {
        say "No AUR packages to install.";
    }
}

sub set_theme {
    my $theme_settings = shift;
    if ($theme_settings) {
        say "Setting theme variables...";
        $ENV{GTK_THEME}         = $theme_settings->{GTK_THEME};
        $ENV{GTK2_RC_FILES}     = $theme_settings->{GTK2_RC_FILES};
        $ENV{QT_STYLE_OVERRIDE} = $theme_settings->{QT_STYLE_OVERRIDE};
        say "Theme variables set.";
    }
    else {
        say "No theme settings to apply.";
    }
}

sub enable_flatpak {
    say "Enabling Flatpak...";
    system("sudo pacman -Sy --needed --noconfirm flatpak");
    system(
"flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo"
    );
    say "Flatpak enabled.";
}

sub setup_docker {
    say "Setting up Docker...";
    system("sudo pacman -Sy --needed --noconfirm docker");
    system("sudo usermod -aG docker $ENV{USER}");
    system("sudo systemctl enable docker.service");
    say "Docker setup complete.";
}

sub setup_git {
    my $git_config = shift;
    if ($git_config) {
        say "Configuring Git...";
        system("git config --global user.name '$git_config->{user_name}'");
        system("git config --global user.email '$git_config->{user_email}'");
        system(
            "git config --global commit.gpgsign $git_config->{commit_gpgsign}");
        system(
            "git config --global user.signingkey '$git_config->{signingkey}'");
        say "Git configured.";
    }
    else {
        say "No Git configuration provided.";
    }
}

sub setup_ssh {
    my $ssh_config = shift;
    if ( $ssh_config && @{ $ssh_config->{keys_to_add} } ) {
        say "Setting up SSH...";
        system("eval \"\$(ssh-agent -s)\"");
        foreach my $key ( @{ $ssh_config->{keys_to_add} } ) {
            system("ssh-add $key");
        }
        say "SSH setup complete.";
    }
    else {
        say "No SSH keys to add.";
    }
}

sub setup_zsh {
    say "Setting up ZSH...";
    system("sudo pacman -Sy --needed --noconfirm zsh stow");
    system("chsh -s \$(which zsh)");
    system(
"sh -c \"\$(curl -fsSL https://raw.githubusercontent .com/ohmyzsh/ohmyzsh/master/tools/install.sh)\""
    );
    say "ZSH setup complete.";
}

sub install_gnome_extensions {
    my @extensions = @_;
    if (@extensions) {
        foreach my $extension (@extensions) {
            say "Installing Gnome extension: $extension";
            system("gnome-extensions install $extension");
        }
        say "Gnome extensions installed.";
    }
    else {
        say "No Gnome extensions to install.";
    }
}

sub install_flatpak_apps {
    my @flatpak_apps = @_;
    if (@flatpak_apps) {
        foreach my $app (@flatpak_apps) {
            say "Installing Flatpak app: $app";
            system("flatpak install -y $app");
        }
        say "Flatpak apps installed.";
    }
    else {
        say "No Flatpak apps to install.";
    }
}

sub hide_menu_entries {
    my @entries = @_;
    if (@entries) {
        foreach my $entry (@entries) {
            say "Hiding menu entry: $entry";
            system("xdg-desktop-menu uninstall $entry");
        }
        say "Menu entries hidden.";
    }
    else {
        say "No menu entries to hide.";
    }
}

my $config = LoadFile('system_setup.yaml');

my @packages_to_remove  = @{ $config->{system_setup}{packages_to_remove} };
my @packages_to_install = @{ $config->{system_setup}{packages_to_install} };
my @aur_packages_to_install =
  @{ $config->{system_setup}{aur_packages_to_install} };
my $theme_settings   = $config->{system_setup}{theme_settings};
my $git_config       = $config->{system_setup}{git_config};
my $ssh_config       = $config->{system_setup}{ssh_config};
my @gnome_extensions = @{ $config->{system_setup}{gnome_extensions} };
my @flatpak_apps_to_install =
  @{ $config->{system_setup}{flatpak_apps_to_install} };
my @hide_menu_entries = @{ $config->{system_setup}{misc}{hide_menu_entries} };

remove_packages(@packages_to_remove);
install_packages(@packages_to_install);
install_aur_packages(@aur_packages_to_install);
set_theme($theme_settings);
enable_flatpak() if $config->{system_setup}{use_flatpak};
setup_docker()   if $config->{system_setup}{setup_docker};
setup_git($git_config);
setup_ssh($ssh_config);
setup_zsh() if $config->{system_setup}{setup_zsh};
install_gnome_extensions(@gnome_extensions);
install_flatpak_apps(@flatpak_apps_to_install);
hide_menu_entries(@hide_menu_entries);

say "All tasks completed.";
