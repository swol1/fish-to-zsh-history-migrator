# Fish to Zsh History Migrator

This is just a script to migrate fish shell history into zsh history.

## Usage

This script can be executed directly from the command line:

Run the script using Ruby. You can optionally specify the paths to your Fish and Zsh history files.

```shell
cd fish-to-zsh-history-migrator
ruby migrate.rb fish_history_path zsh_history_path
```

- `fish_history_path` (optional) - Full path to your fish history file. If not provided, the script will assume the default location (`~/.local/share/fish/fish_history`).
- `zsh_history_path` (optional) - Full path to your zsh history file. If not provided, the script will assume the default location (`~/.zsh_history`).

Example:

```shell
ruby migrate.rb ~/my_custom_path/fish_history ~/my_custom_path/zsh_history
or just to run with default file paths
ruby migrate.rb
```
