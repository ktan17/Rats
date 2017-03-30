//
//  Globals.swift
//  Rats!
//
//  Created by Kevin Tan on 3/27/17.
//  Copyright © 2017 Caked Inc. All rights reserved.
//

import Foundation

struct Globals
{
    
    ///////////////////////////////////////////////////////////////////////////
    // Manifest constants
    ///////////////////////////////////////////////////////////////////////////
    
    static let MAXROWS = 20            // max number of rows in the arena
    static let MAXCOLS = 20            // max number of columns in the arena
    static let MAXRATS = 100           // max number of rats allowed
    static let INITIAL_RAT_HEALTH = 2  // initial rat health
    static let POISONED_IDLE_TIME = 1  // poisoned rat idles this many turns
                                       // between moves
    
    static let NORTH = 0
    static let EAST  = 1
    static let SOUTH = 2
    static let WEST  = 3
    static let NUMDIRS = 4
    
    static let EMPTY      = 0
    static let HAS_POISON = 1
    
}

// Return a uniformly distributed random int from min to max, inclusive
func randInt(min: UInt, max: UInt) -> Int
{
    var num1 = min
    var num2 = max
    
    if min > max
    {
        swap(&num1, &num2)
    }
    
    return Int(arc4random_uniform(UInt32(num2 - num1)) + UInt32(num1))
}

func decodeDirection(ch: Character, dir: inout Int) -> Bool
{
    switch ch
    {
    case "n":
        dir = Globals.NORTH
        break
    case "N":
        dir = Globals.NORTH
        break
    case "e":
        dir = Globals.EAST
        break
    case "E":
        dir = Globals.EAST
        break
    case "s":
        dir = Globals.SOUTH
        break
    case "S":
        dir = Globals.SOUTH
        break
    case "w":
        dir = Globals.WEST
        break
    case "W":
        dir = Globals.WEST
        break
    default:
        return false
    }
    return true
}

// Return false without changing anything if moving one step from (r,c)
// in the indicated direction would run off the edge of the arena.
// Otherwise, update r and c to the position resulting from the move and
// return true.
func attemptMove(a: Arena, dir: Int, r: inout Int, c: inout Int) -> Bool
{
    var rnew = r
    var cnew = c
    
    switch dir
    {
    case Globals.NORTH:
        
        if r <= 1
        {
            return false
        }
            
        else
        {
            rnew -= 1
        }
        
        break
        
    case Globals.EAST:
        
        if c >= a.cols()
        {
            return false
        }
            
        else
        {
            cnew += 1
        }
        
        break
        
    case Globals.SOUTH:
        
        if r >= a.rows()
        {
            return false
        }
            
        else
        {
            rnew += 1
        }
        
        break
        
    case Globals.WEST:
        
        if c <= 1
        {
            return false
        }
            
        else
        {
            cnew -= 1
        }
        
        break
        
    default:
        break
        
    }
    
    r = rnew
    c = cnew
    return true
}

func clearScreen()
{
    print("")
}
