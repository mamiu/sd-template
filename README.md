# Sensitive Dotfiles Template

Sensitive dotfiles are [dotfiles](https://wiki.archlinux.org/title/Dotfiles) which contain confidential information that must be kept safe and out of reach from all outsiders unless they have permission to access it.

This repository helps you to initialize a sensitive dotfiles repository managed by [homeshick](https://github.com/andsens/homeshick).

## Prerequisites

Make sure you have [homeshick installed](https://github.com/andsens/homeshick/wiki/Installation).

## Usage

1. Provide your GitHub username and choose a name for your sensitive dotfiles repository:

   ```bash
   # For bash / zsh shell:
   GITHUB_USERNAME="username"
   SENSITIVE_DOTFILES_REPO="sd"
   # For fish shell:
   set GITHUB_USERNAME "username"
   set SENSITIVE_DOTFILES_REPO "sd"
   ```

2. Clone this repository into `$HOME/.homesick/repos/<NAME_OF_YOUR_SENSITIVE_DOTFILES_REPO>`:

   ```bash
   git clone https://github.com/mamiu/sd-template $HOME/.homesick/repos/$SENSITIVE_DOTFILES_REPO
   ```

3. Create a new private sensitive dotfiles GitHub repository with the name you chose in step 1.

   > **MAKE SURE THAT IT IS A PRIVATE REPOSITORY!!!**  
   > Otherwise, everyone has access to your sensitive dotfiles, which could potentially lead to serious damage.

4. Execute the initialization script in this repo:

   ```bash
   $HOME/.homesick/repos/$SENSITIVE_DOTFILES_REPO/init-sensitive-dotfiles.sh -u $GITHUB_USERNAME -r $SENSITIVE_DOTFILES_REPO
   ```

5. Follow the script output to create a new [deploy key](https://docs.github.com/en/developers/overview/managing-deploy-keys) in your sensitive dotfiles repository (GitHub Repository -> Settings -> Deploy keys -> Add deploy key)

6. Track all the files you want to store in your sensitive dotfiles repository:

   ```bash
   # For each file:
   homeshick track $SENSITIVE_DOTFILES_REPO <FILENAME>
   ```

7. Commit and push all sensitive dotfiles to your sensitive dotfiles repository on GitHub:

   ```bash
   homeshick cd $SENSITIVE_DOTFILES_REPO
   git add -A
   git commit -m "track all sensitive dotfiles"
   git push -u origin main
   ```
