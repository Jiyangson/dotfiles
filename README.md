# My Dotfiles

This repository contains my personal configuration files (dotfiles). It uses a Git bare repository technique to track files directly in the home directory without requiring symlinks, extra tooling, or moving files around.

## The Concept

Instead of a standard Git repository which has a `.git` folder inside the project directory, this method uses a **bare repository** (e.g., in `~/.myconf`) to store the Git database. Then, a special alias (`config`) is used to tell Git to use this database to manage the files in a different working directory—in this case, the home directory (`$HOME`).

This allows you to version control any file in your home directory as if it were a normal Git project.

## Quick Setup on a New Machine

To deploy these dotfiles on a new machine, follow these steps.

### 1. Clone the Bare Repository

First, clone this repository as a bare repository into a dedicated directory in your home folder. A common convention is `.myconf`.

```bash
# Replace the URL with your repository's URL
git clone --bare git@github.com:your-username/dotfiles.git $HOME/.myconf
```

### 2. Define the `config` Alias

Next, create the special `config` alias that tells Git how to interact with your dotfiles. Add the following line to your shell's configuration file (e.g., `~/.bashrc` or `~/.zshrc`).

```bash
# For bash:
echo "alias config='/usr/bin/git --git-dir=$HOME/.myconf/ --work-tree=$HOME'" >> ~/.bashrc

# For zsh:
echo "alias config='/usr/bin/git --git-dir=$HOME/.myconf/ --work-tree=$HOME'" >> ~/.zshrc
```

Now, apply the alias to your current session by sourcing the file or opening a new terminal.

```bash
source ~/.bashrc
# Or: source ~/.zshrc
```

### 3. Check Out the Configuration Files

Now you need to check out the actual files from the repository into your home directory. A fresh system often has default dotfiles, which Git will refuse to overwrite.

The following commands will back up any conflicting default files and then safely check out your versions.

```bash
# 1. Create a backup directory
mkdir -p .config-backup

# 2. Try to check out. This will likely fail but list the conflicting files.
config checkout

# 3. If it failed, move the conflicting files to the backup directory.
# This command finds the files that would be overwritten and moves them.
config checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} .config-backup/{}

# 4. Try the checkout again. It should now succeed.
config checkout
```

### 4. Configure the Repository

Finally, configure the local repository to hide the thousands of other untracked files in your home directory from the status command.

```bash
config config --local status.showUntrackedFiles no
```

Your setup is now complete!

## Daily Usage

Managing your dotfiles now works just like any other Git repository, but using your `config` alias instead of `git`.

*   **Check status:**
    ```bash
    config status
    ```

*   **See modifications:**
    ```bash
    config diff
    config diff .vimrc
    ```

*   **Add and commit changes:**
    ```bash
    config add .vimrc
    config commit -m "Update vimrc with new setting"
    ```

*   **Push and pull to stay in sync:**
    ```bash
    # Push changes to GitHub
    config push

    # Pull changes on another machine
    config pull
    ```
