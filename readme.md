Convert de-compressed epubs to markdown
=======================================

## dependencies
```
rvm with ruby 1.9.3
bundler 1.2+
```

## initial install
```bash
$ gem install bundler
# => installs the latest bundler into the current gemset

$ bundle install
# => installs the gem dependencies
```


Using the dang thing
--------------------

Place the target epub folders in the `./source` directory with downcased folder names.

Then run `rake run`