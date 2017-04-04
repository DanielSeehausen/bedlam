


# Bedlam

Built off of Joel Besada's 'activate-power-mode'.
Bedlam mode differs in the following ways:

### Bedlam changes
* avg. streak implemented and displayed
* power benchmarking implemented (currentStreak/avgStreak)
  * screen shake severity now proportional to power (still max/min @ user set boundaries)
  * num of particles now proportional to power (still max/min @ user set boundaries)
  * particle color saturation now proportional to power (with a floor set)
  * combo counter size now proportional to power with upper/lower bounds set to 30/120px
  * combo counter color now proportional to power
  * bar set to use same color transitions
  * added getComboCountColor() and its helper function interpolateColor to color-helper
* max power implemented
  * when true, the counter and bar transition colors and glow
  * counter and bar have separate keyframe functions as one uses the background color/box shadow and the other uses text color/shadow
* explosions canvas added
  * cluster of explosions occurs when the combo css transitions to neon
  * can be implemented anywhere else as well
* additional sound effects added
* combo counter only shows once beyond the activation threshold

#

A package for Atom to replicate the effects from [codeinthedark/editor](https://github.com/codeinthedark/editor).

![bedlam-0 4 0](https://cloud.githubusercontent.com/assets/688415/11615565/10f16456-9c65-11e5-8af4-265f01fc83a0.gif)

Now with a COMBO MODE!!!

![bedlam-combo](https://cloud.githubusercontent.com/assets/10590799/18817237/876c2d84-8321-11e6-8324-f1540604c0bd.gif)

**For a list of power mode packages to other editors, check out [codeinthedark/awesome-power-mode](https://github.com/codeinthedark/awesome-power-mode).**

## Install

With the atom package manager:
```bash
apm install bedlam
```
Or Settings ➔ Packages ➔ Search for `bedlam`

## Usage

- Activate with <kbd>Ctrl</kbd>-<kbd>Alt</kbd>-<kbd>O</kbd> or through the command panel with `Activate Power Mode: Toggle`. Use the command again to deactivate.

**IMPORTANT: When `Combo Mode` is enabled, particles and other effects won't appear until you reach the activation threshold.**

- Reset the max combo streak with the command `Activate Power Mode: Reset Max Combo`

## Settings

### Auto Toggle
Auto enable power mode on atom start.

### Combo Mode
* **Enable/Disable**

**When enabled effects won't appear until reach the activation threshold.**

* Activation Threshold
* Streak Timeout
* Exclamation Every
* Exclamation Texts

### Screen Shake
* **Enable/Disable**
* Intensity

### Play Audio
* **Enable/Disable**
* Volume
* Audioclip (Gun, Typewriter, Custom)

### Particles
* **Enable/Disable**
* Colour

With this option you can select if use the color at cursor position, random colors or a fixed one.

* Total Count
* Spawn Count
* Size

### Excluded File Types
* Array of file types to exclude
