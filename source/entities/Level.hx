package entities;

import haxepunk.*;
import haxepunk.graphics.*;
import haxepunk.graphics.tile.*;
import haxepunk.masks.*;
import haxepunk.math.*;
import openfl.Assets;

class Level extends Entity
{
    public static inline var SCALE = 2;

    private var walls:Grid;
    private var tiles:Tilemap;

    public function new(levelName:String) {
        super(0, 0);
        type = "walls";
        walls = new Grid(Std.int(1920 / SCALE), Std.int(360 / SCALE), 20, 20);
        fill();
        updateGraphic();
    }

    public function fill() {
        for(tileX in 0...walls.columns) {
            for(tileY in 0...walls.rows) {
                walls.setTile(tileX, tileY, true);
            }
        }
    }

    private function getNumSolidsIn3x3Region(centerX:Int, centerY:Int) {
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

    public function getSolidPercentage() {
        var solidCount = 0;
        for(tileX in 0...walls.columns) {
            for(tileY in 0...walls.rows) {
                if(getTile(tileX, tileY)) {
                    solidCount += 1;
                }
            }
        }
        return solidCount / (walls.rows * walls.columns);
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

    public function drunkenWalk(steps:Int = 100) {
        var walker = {x: Random.randInt(walls.columns - 2) + 1, y: Std.int(walls.rows - 2) + 1}
        for(i in 0...steps) {
            walls.setTile(walker.x, walker.y, false);
            if(Random.random < 0.9) {
                walker.x += HXP.choose(-1, 1);
            }
            else {
                walker.y += HXP.choose(-1, 1);
            }
            walker.x = MathUtil.iclamp(walker.x, 1, walls.columns - 1);
            walker.y = MathUtil.iclamp(walker.y, 1, walls.rows - 1);
        }
    }

    public function cellularAutomata() {
        var wallsCopy = new Grid(walls.width, walls.height, walls.tileWidth, walls.tileHeight);
        for(tileX in 0...walls.columns) {
            for(tileY in 0...walls.rows) {
                var numSolidsIn3x3Region = getNumSolidsIn3x3Region(tileX, tileY);
                var hasEnoughNeighbors = numSolidsIn3x3Region >= 5;
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
            walls.width, walls.height, 20, 20
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

    public function export(mapX:Int, mapY:Int) {
        var wallsCopy = new Grid(walls.width * SCALE, walls.height * SCALE, walls.tileWidth, walls.tileHeight);
        for(tileX in 0...walls.columns) {
            for(tileY in 0...walls.rows) {
                wallsCopy.setTile(tileX * SCALE, tileY * SCALE, walls.getTile(tileX, tileY));
                wallsCopy.setTile(tileX * SCALE + 1, tileY * SCALE, walls.getTile(tileX, tileY));
                wallsCopy.setTile(tileX * SCALE, tileY * SCALE + 1, walls.getTile(tileX, tileY));
                wallsCopy.setTile(tileX * SCALE + 1, tileY * SCALE + 1, walls.getTile(tileX, tileY));
            }
        }

        var bitstring = wallsCopy.saveToString("", "\n", "1", "0");
        var export =
'<level width="1920" height="360">
    <solids exportMode="Bitstring">${bitstring}</solids>
</level>';
        var fileName = '${mapX}x${mapY}.oel';
        sys.io.File.saveContent('../../../${fileName}', export);
    }
}
