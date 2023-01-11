package scenes;

import entities.*;
import haxepunk.*;
import haxepunk.graphics.*;
import haxepunk.graphics.tile.*;
import haxepunk.input.*;
import haxepunk.masks.*;
import haxepunk.math.*;
import haxepunk.Tween;
import haxepunk.tweens.misc.*;
import haxepunk.utils.*;
import openfl.Assets;

class GameScene extends Scene
{
    private var level:Level;

    override public function begin() {
        level = new Level("level");
        add(level);
    }

    override public function update() {
        if(Key.pressed(Key.R)) {
            level.randomize();
            level.updateGraphic();
        }
        else if(Key.pressed(Key.C)) {
            level.cellularAutomata();
            level.updateGraphic();
        }
        super.update();
    }
}
