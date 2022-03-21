# Sensitive Dotfiles Template

Sensitive dotfiles are [dotfiles](https://wiki.archlinux.org/title/Dotfiles) which contain confidential information that must be kept safe and out of reach from all outsiders unless they have permission to access it.

This repository helps you to initialize a sensitive dotfiles repository managed by [homeshick](https://github.com/andsens/homeshick).

## Requirements

Make sure you have [homeshick installed](https://github.com/andsens/homeshick/wiki/Installation).

## Usage

1. Clone this repository into `$HOME/.homesick/repos/sd` (adjust the folder name if you want to give your sensitive dotfiles a different name):

   ```bash
   git clone https://github.com/mamiu/sd-template $HOME/.homesick/repos/sd
   ```

2. Create a new private sensitive dotfiles repository in your GitHub account (**MAKE SURE THAT IT IS A PRIVATE REPOSITORY!!!**)

3. Execute the initialization script in this repo:

   ```bash
   $HOME/.homesick/repos/sd/init-sensitive-dotfiles.sh
   ```

4. Follow the script output to create a new [deploy key](https://docs.github.com/en/developers/overview/managing-deploy-keys) in your sensitive dotfiles repository (GitHub Repository -> Settings -> Deploy keys -> Add deploy key)

5. Track all the files you want to store in your sensitive dotfiles repository:

   ```bash
   # For each file:
   homeshick track sd <FILENAME>
   ```

6. Commit and push all sensitive dotfiles to your sensitive dotfiles repository on GitHub:

   ```bash
   homeshick cd sd
   git add -A
   git commit -m "track all sensitive dotfiles"
   git push -u origin main
   ```
