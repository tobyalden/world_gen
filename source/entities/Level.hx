package entities;

import haxepunk.*;
import haxepunk.graphics.*;
import haxepunk.graphics.tile.*;
import haxepunk.masks.*;
import haxepunk.math.*;
import openfl.Assets;

class Level extends Entity
{
    private var walls:Grid;
    private var tiles:Tilemap;

    public function new(levelName:String) {
        super(0, 0);
        type = "walls";
        walls = new Grid(1920, 360, 10, 10);
        updateGraphic();
    }

    private function getSolidsIn3x3Region(centerX:Int, centerY:Int) {
        var solidCount = 0;
        for(tileX in (centerX - 1)...(centerX + 2)) {
            for(tileY in (centerY - 1)...(centerY + 2)) {
                if(getTile(tileX, tileY)) {
                    solidCount += 1;
                }
            }
        }
        return solidCount;
    }

    public function randomize(solidChance:Float = 0.5) {
        for(tileX in 0...walls.columns) {
            for(tileY in 0...walls.rows) {
                walls.setTile(tileX, tileY, Random.random < solidChance);
            }
        }
    }

    public function makeWalls() {
        for(tileX in 0...walls.columns) {
            for(tileY in 0...walls.rows) {
                if(tileX == 0 || tileX == walls.columns - 1 || tileY == 0 || tileY == walls.rows - 1) {
                    walls.setTile(tileX, tileY, true);
                }
            }
        }
    }

    public function cellularAutomata() {
        var wallsCopy = new Grid(walls.width, walls.height, walls.tileWidth, walls.tileHeight);
        for(tileX in 0...walls.columns) {
            for(tileY in 0...walls.rows) {
                var hasEnoughNeighbors = getSolidsIn3x3Region(tileX, tileY) >= 5;
                wallsCopy.setTile(tileX, tileY, hasEnoughNeighbors);
            }
        }
        walls.loadFromString(wallsCopy.saveToString(",", "\n", "1", "0"));
    }

    private function getTile(tileX:Int, tileY:Int) {
        if(tileX < 0 || tileX >= walls.columns || tileY < 0 || tileY >= walls.rows) {
            return true;
        }
        return walls.getTile(tileX, tileY);
    }

    override public function update() {
        super.update();
    }

    public function updateGraphic() {
        tiles = new Tilemap(
            'graphics/tiles.png',
            walls.width, walls.height, 10, 10
        );
        for(tileX in 0...walls.columns) {
            for(tileY in 0...walls.rows) {
                if(walls.getTile(tileX, tileY)) {
                    tiles.setTile(tileX, tileY, 0);
                }
            }
        }
        graphic = tiles;
    }
}

