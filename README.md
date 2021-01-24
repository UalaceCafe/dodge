# About

A simple game based on Dani's [Making a Game in ONE HOUR](https://www.youtube.com/watch?v=EGBvvlgbJVM) video using the [Ruby2D](http://www.ruby2d.com/) gem. 
This is also my first game.

The game was made with a Nintendo Entertainment System (NES) vibe in mind, so it uses NES standard resolutions, like 

- 256x240 display resolution
- 16x16 and 32x32 sprites
etc.

It's very much playable with this resolution, but you can resize the game window if you need to.

![repo_cover](https://i.imgur.com/Z7G5xs7.gif=100x200)

## Objectives

- Learn the basics of making a game;
- Learn the basics of pixel art;
- Create my first game;
- Understand and write game logic, collision detection and animation;
- Test and use my Particle System.

## Todo

- [ ] Improve physics, animations and UI;
- [ ] Fix jetpack trail spawn location;
- [ ] Optimize and refactor code;
- [x] Improve FPS;
- [ ] Add sound;
- [x] Add music;
- [ ] Be more creative ;).

# Install

* [Ruby2d](https://github.com/ruby2d/ruby2d):

```
gem install ruby2d
```

Then clone the source to your local:

```
git clone https://github.com/UalaceCafe/dodge
```

# Play

```
cd dodge
ruby dodge.rb
```

# Controls

* Use jetpack: space bar
* Start and Restart: space bar
* If you get hit by an asteroid or fall bellow the screen you DIE

# Credits

- Ruby2D Team for the [Ruby2D gem](https://github.com/ruby2d/ruby2d);
<!-- - [Carlos Vagner](https://github.com/glitchysnitchy) for the game music; -->
- Jeffrey Thompson for the [Rectangle-Circle Collision Algorithm](http://www.jeffreythompson.org/collision-detection/circle-rect.php);
- u/astrellon3 for the [Background Image](https://www.reddit.com/r/PixelArt/comments/f1wg26/space_background);
- John Nesky for the [Beepbox](https://www.beepbox.co) website where the game music was made;
- Assets, code and the 'math_2d' and 'ruby2d_extras' libraries were made by me.