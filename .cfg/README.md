# DOTFILES

- This leverages the git bare repository.

### Initialize a bare repository using 
```sh
git init --bare $HOME/.cfg 
```

- This will create a `.cfg` directory in the home folder.

### Add this to either your `.zshrc` or `.bashrc` depending on whats used

```sh 
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME
```
```
```

and source

### Disable showUntrackedFiles
```bash
config config --local status.showUntrackedFiles no
```
this will ignore all the files here so that we can focus on whats really important
```
```


### Commands for pushing
```bash
config status
config add .vimrc
config commit -m "Add vimrc"
config add .bashrc
config commit -m "Add bashrc"
config push
```
```
```

#### References
- [Atlassian git tutorials]('https://www.atlassian.com/git/tutorials/dotfiles')
