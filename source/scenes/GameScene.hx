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
        camera.scale = 0.5;
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
        else if(Key.pressed(Key.E)) {
            level.export();
        }
        super.update();
    }
}
