//
//  Map.swift
//  GemDefense
//
//  Created by Peter Holko on 2016-05-21.
//  Copyright © 2016 Peter Holko. All rights reserved.
//


let TILE_SIZE = 13

enum Tile {
    case empty
    case blocked
    case restricted
}

struct Point: Hashable {
    let x: Int
    let y: Int
    var hashValue: Int { return (Int) (x.hashValue * 31 + y.hashValue) }
}

func == (lhs: Point, rhs: Point) -> Bool {
    return lhs.x == rhs.x && lhs.y == rhs.y
}

class Map {
   
    let WIDTH: Int = 40
    let HEIGHT: Int = 40
 
    var tiles: [[Tile]] = [[Tile]]()
    
    var start: Point = Point(x: 0, y: 0)
    var goal: Point = Point(x: 0, y: 0)
 
    init() {
        for i in 0..<WIDTH {
            tiles.append([Tile]())
            
            for _ in 0..<HEIGHT {
                let tile: Tile = .empty

                tiles[i].append(tile)
            }
        }
    }

    func heuristic(_ p: Point) -> Float {  // Manhattan distance
       let xdist = abs(p.x - goal.x)
       let ydist = abs(p.y - goal.y)
       return Float(xdist + ydist)
    }
    
    func goalTest(_ x: Point) -> Bool {
        if x == goal {
            return true
        }
    
        return false
    }
            
    func successors(_ p: Point) -> [Point] { //can't go on diagonals
        var ar: [Point] = [Point]()

        if (p.x + 1 < WIDTH) && (tiles[p.x + 1][p.y] != .blocked) {
            ar.append(Point(x: p.x + 1, y: p.y))
        }
        if (p.x - 1 >= 0) && (tiles[p.x - 1][p.y] != .blocked) {
            ar.append(Point(x: p.x - 1, y: p.y))
        }
        if (p.y + 1 < HEIGHT) && (tiles[p.x][p.y + 1] != .blocked) {
            ar.append(Point(x: p.x, y: p.y + 1))
        }
        if (p.y - 1 >= 0) && (tiles[p.x][p.y - 1] != .blocked) {
            ar.append(Point(x: p.x, y: p.y - 1))
        }
        
        return ar
    }

    func findPath(_ startX: Int, startY: Int, goalX: Int, goalY: Int) -> [Point] {
        start = Point(x: startX, y: startY)
        goal = Point(x: goalX, y: goalY)
        
        if let pathresult: [Point] = astar(start, goalTestFn: goalTest, successorFn: successors, heuristicFn: heuristic) {
            return pathresult
        }
        else {
            return []
        }
    }

    func getTile(x: Int, y:Int) -> Tile {
        if(x < 0 ||  y < 0 || 
           x >= WIDTH || y >= HEIGHT) {
            return Tile.restricted
        } else {
            return tiles[x][y]
        }
    }
    
    func setRestricted(_ x: Int, y: Int) {
        tiles[x][y] = .restricted
    }

    func setBlocked(_ x: Int, y: Int) {
        tiles[x][y] = .blocked
    }
    
    func setEmpty(_ x: Int, y: Int) {
        tiles[x][y] = .empty
    }
}
