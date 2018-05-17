[![](https://github.com/AxolStudio/Atlas/blob/master/website/_assets/images/color-logo.png?raw=true)](https://atlas.axolstudio.com/)

# Atlas
Collaborative Cartography Experiment Project

This is the Open Source Code for the Atlas Project, which can be found at https://atlas.axolstudio.com/

If you want to try it out on your own server, use `setup\Database.sql' to setup your database, and change `website\scripts\credentials.php.temp' to have your own credentials, then rename it (remove the '.temp').

You will need to use [Jekyll](https://jekyllrb.com/) to build the website from `website`, and deploy `website\_site` to your webserver.

If you wish to make changes to the components (`atlas-map`, `atlas-editor`, `atlas-viewer`) you will need [HaxeFlixel](https://haxeflixel.com/)

* When you build a component, it will generate a file in `{component name}\export\html5\{component name}.js`. 
* Move this file to `website\assets\js\`
* Then, you'll need to edit the `.js` file and append `{name}Embed = lime.embed;`, where name is based on the component: (I know this is complicated, I'm trying to figure out a good way to simplify this!) 
  * `atlas-editor` = `editor`
  * `atlas-viewer` = `viewer`
  * `atlas-map` = `scrollingMap`. 
* Finally, you can `build` with Jekyll and deploy to your server.
