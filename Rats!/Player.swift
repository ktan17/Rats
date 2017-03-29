//
//  Player.swift
//  Rats!
//
//  Created by Kevin Tan on 3/27/17.
//  Copyright © 2017 Caked Inc. All rights reserved.
//

import Foundation

class Player
{
    private var m_arena: Arena?
    private var m_row:   Int
    private var m_col:   Int
    private var m_dead:  Bool
    
    init(ap: Arena?, r: Int, c: Int)
    {
        guard ap != nil else
        {
            print("***** A Player must be created in some Arena!")
            exit(1)
        }
        
        if r < 1  ||  r > (ap?.rows())!  ||  c < 1  ||  c > (ap?.cols())!
        {
            print("***** Player created with invalid coordinates (", r, ", ", c, ")!")
            exit(1)
        }
        
        m_arena = ap
        m_row = r
        m_col = c
        m_dead = false
    }
    
    // Accessors
    
    public func row() -> Int
    {
        return m_row
    }
    
    public func col() -> Int
    {
        return m_col
    }
    
    public func dropPoisonPellet() -> String
    {
        if m_arena?.getCellStatus(r: m_row, c: m_col) == Globals.HAS_POISON
        {
            return "There's already a poison pellet at this spot."
        }
        m_arena?.setCellStatus(r: m_row, c: m_col, status: Globals.HAS_POISON)
        return "A poison pellet has been dropped."
    }
    
    public func move(dir: Int) -> String
    {
        if attemptMove(a: m_arena!, dir: dir, r: &m_row, c: &m_col)
        {
            if ((m_arena?.numberOfRatsAt(r: m_row, c: m_col))! > 0)
            {
                setDead()
                return "Player walked into a rat and died."
            }
            var msg = "Player moved "
            switch dir
            {
            case Globals.NORTH: msg += "north"; break;
            case Globals.EAST:  msg += "east";  break;
            case Globals.SOUTH: msg += "south"; break;
            case Globals.WEST:  msg += "west";  break;
            default:            break
            }
            msg += "."
            return msg
        }
            
        else
        {
            return "Player couldn't move; player stands."
        }
    }
    
    public func isDead() -> Bool
    {
        return m_dead
    }
    
    public func setDead()
    {
        m_dead = true
    }
    
}
