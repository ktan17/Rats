//
//  Rat.swift
//  Rats!
//
//  Created by Kevin Tan on 3/27/17.
//  Copyright © 2017 Caked Inc. All rights reserved.
//

import Foundation

class Rat
{
    private var m_row:                  Int
    private var m_col:                  Int
    private var m_health:               Int
    private var m_idleTurnsRemaining:   Int
    private var m_arena:                Arena?
    
    init(ap: Arena?, r: Int, c: Int)
    {
        guard ap != nil else
        {
            print("***** A rat must be created in some Arena!")
            exit(1)
        }
        
        if r < 1  ||  r > (ap?.rows())!  ||  c < 1  ||  c > (ap?.cols())!
        {
            print("***** Rat created with invalid coordinates (", r, ", ", c, ")!")
            exit(1)
        }
        
        m_arena = ap
        m_row = r
        m_col = c
        m_health = Globals.INITIAL_RAT_HEALTH
        m_idleTurnsRemaining = 0
    }
    
    // Accesors
    
    public func row() -> Int
    {
        return m_row
    }
    
    public func col() -> Int
    {
        return m_col
    }
    
    public func isDead() -> Bool
    {
        return m_health == 0
    }
    
    // Mutators
    
    public func move()
    {
        if m_idleTurnsRemaining > 0
        {
            m_idleTurnsRemaining -= 1
            return
        }
        
        // Attempt to move in a random direction; if we can't move, don't move
        if (attemptMove(a: m_arena!, dir: randInt(min: 0, max: UInt(Globals.NUMDIRS-1)), r: &m_row, c: &m_col))
        {
            if m_arena?.getCellStatus(r: m_row, c: m_col) == Globals.HAS_POISON
            {
                if self.m_health == Globals.INITIAL_RAT_HEALTH
                {
                    let _ = m_arena?.history().record(r: m_row, c: m_col)
                }
                m_arena?.setCellStatus(r: m_row, c: m_col, status: Globals.EMPTY)
                m_health -= 1
            }
        }
        
        if m_health < Globals.INITIAL_RAT_HEALTH
        {
            m_idleTurnsRemaining = Globals.POISONED_IDLE_TIME
        }
    }
    
}
