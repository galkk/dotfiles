#!/usr/bin/env bash
# macOS defaults — run once, reboot to apply all

set -e

# Key repeat instead of accent picker
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Expanded save/print dialogs by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# Kill smart quotes, dashes, autocorrect (break pasting into terminals)
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

# Finder: full POSIX path in title, search current folder, show extensions
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
defaults write com.apple.finder AppleShowAllExtensions -bool true

# Dock: instant autohide
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0

# Tighter menu bar icon spacing
defaults -currentHost write -globalDomain NSStatusItemSpacing -int 2
defaults -currentHost write -globalDomain NSStatusItemSelectionPadding -int 2

# Screenshots: no shadow
defaults write com.apple.screencapture disable-shadow -bool true

# No quarantine dialogs for downloaded apps
defaults write com.apple.LaunchServices LSQuarantine -bool false

# TextEdit: plain text by default
defaults write com.apple.TextEdit RichText -int 0

killall Dock Finder 2>/dev/null || true

echo "Done. Some changes require reboot."
