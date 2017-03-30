//
//  Game.swift
//  Rats!
//
//  Created by Kevin Tan on 3/27/17.
//  Copyright © 2017 Caked Inc. All rights reserved.
//

import Foundation
import Darwin

class Game
{
    private var m_arena: Arena?
    
    init(rows: Int, cols: Int, nRats: Int)
    {
        if nRats < 0
        {
            print("***** Cannot create Game with negative number of rats!")
            exit(1)
        }
        
        if nRats > Globals.MAXRATS
        {
            print("***** Trying to create Game with ", nRats, " rats; only ", Globals.MAXRATS, " are allowed!")
            exit(1)
        }
        
        if rows == 1  &&  cols == 1  &&  nRats > 0
        {
            print("***** Cannot create Game with nowhere to place the rats!")
            exit(1)
        }
        
        // Create arena
        m_arena = Arena(nRows: rows, nCols: cols)
        
        // Add player
        var rPlayer: Int
        var cPlayer: Int
        repeat
        {
            rPlayer = randInt(min: 1, max: UInt(rows))
            cPlayer = randInt(min: 1, max: UInt(cols))
        } while m_arena?.getCellStatus(r: rPlayer, c: cPlayer) != Globals.EMPTY
        
        let _ = m_arena?.addPlayer(r: rPlayer, c: cPlayer)
        
        // Populate with rats
        var temp = nRats
        while temp > 0
        {
            let r = randInt(min: 1, max: UInt(rows))
            let c = randInt(min: 1, max: UInt(cols))
            if r == rPlayer && c == cPlayer
            {
                continue
            }
            let _ = m_arena?.addRat(r: r, c: c)
            temp -= 1
        }
    }
    
    // Mutators
    
    public func takePlayerTurn() -> String
    {
        while true
        {
            print("Your move (n/e/s/w/x or nothing): ")
            var playerMove = readLine()!
            
            let player = m_arena?.player()
            var dir = 0
            
            if playerMove.characters.count == 0
            {
                if recommendMove(a: m_arena!, r: (player?.row())!, c: (player?.col())!, bestDir: &dir)
                {
                    return player!.move(dir: dir)
                }
                    
                else
                {
                    return player!.dropPoisonPellet()
                }
            }
            else if playerMove.characters.count == 1
            {
                if Character(playerMove) == "x" || Character(playerMove) == "X"
                {
                    return player!.dropPoisonPellet()
                }
                    
                else if Character(playerMove) == "h"
                {
                    
                    m_arena?.history().display()
                    
                    print("Press enter to continue.")
                    let _ = readLine()
                    m_arena?.display(msg: "")
                    continue
                    
                }
                    
                else if decodeDirection(ch: Character(playerMove), dir: &dir)
                {
                    return player!.move(dir: dir)
                }
            }
            print("Player move must be nothing, or 1 character n/e/s/w/x.")
        }
    }
    
    public func play()
    {
        m_arena?.display(msg: "")
        while !(m_arena?.player()?.isDead())!  &&  (m_arena?.ratCount())! > 0
        {
            let msg = takePlayerTurn()
            let player = m_arena?.player()
            
            if (player?.isDead())!
            {
                print(msg)
                break
            }
            
            m_arena?.moveRats()
            m_arena?.display(msg: msg)
        }
        if (m_arena?.player()?.isDead())!
        {
            print("You lose.")
        }
        else
        {
            print("You win.")
        }
    }
    
    // Helper Functions
    
    private func computeDanger(a: Arena, r: Int, c: Int) -> Int
    {
        // Our measure of danger will be the number of rats that might move
        // to position r,c.  If a rat is at that position, it is fatal,
        // so a large value is returned.
        
        if a.numberOfRatsAt(r: r,c: c) > 0
        {
            return Globals.MAXRATS+1
        }
        
        var danger = 0
        if r > 1
        {
            danger += a.numberOfRatsAt(r: r-1,c: c)
        }
        if r < a.rows()
        {
            danger += a.numberOfRatsAt(r: r+1,c: c)
        }
        if c > 1
        {
            danger += a.numberOfRatsAt(r: r,c: c-1)
        }
        if c < a.cols()
        {
            danger += a.numberOfRatsAt(r: r,c: c+1)
        }
        
        return danger
    }
    
    // Recommend a move for a player at (r,c):  A false return means the
    // recommendation is that the player should drop a poison pellet and not
    // move; otherwise, this function sets bestDir to the recommended
    // direction to move and returns true.
    private func recommendMove(a: Arena, r: Int, c: Int, bestDir: inout Int) -> Bool
    {
        // How dangerous is it to stand?
        let standDanger = computeDanger(a: a, r: r, c: c)
        
        // if it's not safe, see if moving is safer
        if standDanger > 0
        {
            var bestMoveDanger = standDanger
            var bestMoveDir = Globals.NORTH  // arbitrary initialization
            
            // check the four directions to see if any move is
            // better than standing, and if so, record the best
            for dir in 0 ... Globals.NUMDIRS-1
            {
                var rnew = r
                var cnew = c
                if attemptMove(a: a, dir: dir, r: &rnew, c: &cnew)
                {
                    let danger = computeDanger(a: a, r: rnew, c: cnew)
                    if danger < bestMoveDanger
                    {
                        bestMoveDanger = danger
                        bestMoveDir = dir
                    }
                }
            }
            
            // if moving is better than standing, recommend move
            if bestMoveDanger < standDanger
            {
                bestDir = bestMoveDir
                return true
            }
        }
        return false  // recommend standing
    }
}
