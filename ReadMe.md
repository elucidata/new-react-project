# Base React Project

Brunch project skeleton for use with React.js that includes react-brunch, react-tags-brunch, coffee-script, react-coffee, bootstrap, jquery, ogre-js.

## Getting Started

```bash
brunch new gh:elucidata/new-react-project my-nifty-app
cd my-nifty-app
cake init
```

**Note:** If you don't have CoffeeScript installed globally, that last line will need to look like this: 

```bash
./node_modules/.bin/cake init
```

If you don't want CoffeeScript installed globally, I'd add the following to your `.bash_profile`:

```bash
export PATH=$PATH:./node_modules/.bin
```

Then you can just call `cake` and it will use the local version.

Speaking of which...

## Default Cake Tasks


    cake init                 # Initialize setup
    cake build                # Builds the app into ./public
    cake build:dist           # Calls tasks: clean, version:update, build:production
    cake build:production     # Builds optimized app into ./public
    cake build:watch          # Watch ./app and autobuild to ./public on change
    cake build:server         # Starts dev server
    cake clean                # Removes ./public
    cake docs                 # Build API docs
    cake fonts:bootstrap      # Copy Bootstrap fonts to ./app/assets/fonts/
    cake fonts:font-awesome   # Copy FontAwesome fonts to ./app/assets/fonts/
    cake notes                # Show all annotations in source
    cake notes:todo           # Show 'TODO:' annotations in source
    cake notes:fixme          # Show 'FIXME:' annotations in source
    cake notes:optimize       # Show 'OPTIMIZE:' annotations in source
    cake notes:hack           # Show 'HACK:' annotations in source
    cake notes:review         # Show 'REVIEW:' annotations in source
    cake notes:note           # Show 'NOTE:' annotations in source
    cake version              # Prints current app version
    cake version:update       # Updates all the files that contain version info

      -f, --force        (ver) Force updating for version files


## IE 8

For IE 8 support, you'll need to update `bower.json` to reference `"jquery": "1.1.x"` instead of `"jquery": ">=2.0",`. That's it.