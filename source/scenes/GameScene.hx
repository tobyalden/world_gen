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
        else if(Key.pressed(Key.F)) {
            level.fill();
            level.updateGraphic();
        }
        else if(Key.pressed(Key.D)) {
            level.drunkenWalk();
            level.updateGraphic();
        }
        else if(Key.pressed(Key.G)) {
            do {
                level.randomize(0.45 + Random.random * 0.1);
                for(i in 0...Random.randInt(2)) {
                    level.drunkenWalk(Random.randInt(100) + 50);
                }
                for(i in 0...(Random.randInt(1) + 1)) {
                    level.cellularAutomata();
                }
                for(i in 0...Random.randInt(2)) {
                    level.drunkenWalk(Random.randInt(100) + 50);
                }
                for(i in 0...Random.randInt(2)) {
                    level.cellularAutomata();
                }
            } while (level.getSolidPercentage() < 0.25);
            level.updateGraphic();
        }
        else if(Key.pressed(Key.E)) {
            level.export(1000, 1000);
        }
        super.update();
    }
}
