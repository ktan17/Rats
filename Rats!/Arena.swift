//
//  Arena.swift
//  Rats!
//
//  Created by Kevin Tan on 3/27/17.
//  Copyright © 2017 Caked Inc. All rights reserved.
//

import Foundation

class Arena
{
    private var m_grid:     Array<Array<Int>>
    private var m_rows:     Int
    private var m_cols:     Int
    private var m_player:   Player?
    private var m_rats:     Array<Rat>
    private var m_history:  History!
    private var m_nRats:    Int
    private var m_turns:    Int
    
    init (nRows: Int, nCols: Int) {
        
        if nRows <= 0  ||  nCols <= 0  ||  nRows > Globals.MAXROWS  ||  nCols > Globals.MAXCOLS
        {
            print("***** Arena created with invalid size ", nRows, " by ", nCols, "!")
            exit(1);
        }
        
        m_grid = Array(repeating: Array(repeating: Globals.EMPTY, count: nCols), count: nRows)
        m_rows = nRows
        m_cols = nCols
        m_player = nil
        m_rats = Array<Rat>()
        m_history = History(nRows: nRows, nCols: nCols)
        m_nRats = 0
        m_turns = 0
        
    }
    
    // Accesors
    
    public func rows() -> Int
    {
        return m_rows
    }
    
    public func cols() -> Int
    {
        return m_cols
    }
    
    public func player() -> Player?
    {
        return m_player;
    }
    
    public func ratCount() -> Int
    {
        return m_nRats;
    }
    
    public func getCellStatus(r: Int, c: Int) -> Int
    {
        checkPos(r: r, c: c);
        return m_grid[r-1][c-1];
    }
    
    public func numberOfRatsAt(r: Int, c: Int) -> Int
    {
        var count = 0
        for rat in m_rats
        {
            if rat.row() == r  &&  rat.col() == c {
                count += 1
            }
        }
        return count;
    }
    
    // Mutators
    
    public func display(msg: String)
    {
        var displayGrid = [[Character]]()
        
        // Fill displayGrid with dots (empty) and stars (poison pellets)
        for r in 1 ... rows()
        {
            displayGrid.append(Array<Character>())
            for c in 1 ... cols()
            {
                displayGrid[r-1].append(getCellStatus(r: r,c: c) == Globals.EMPTY ? "." : "*")
            }
        }
        
        // Indicate each rat's position
        for rat in m_rats
        {
            let gridChar = displayGrid[rat.row()-1][rat.col()-1]
            
            switch (gridChar)
            {
            case ".":  displayGrid[rat.row()-1][rat.col()-1] = "R"; break;
            case "R":  displayGrid[rat.row()-1][rat.col()-1] = "2"; break;
            case "9":  break;
            default:
                let newNum = Int(String(gridChar))! + 1
                displayGrid[rat.row()-1][rat.col()-1] = Character(String(newNum))
                break  // '2' through '8'
            }
        }
        
        // Indicate player's position
        if m_player != nil
        {
            displayGrid[(m_player?.row())!-1][(m_player?.col())!-1] = ((m_player?.isDead())! ? "X" : "@")
        }
        
        // Draw the grid
        clearScreen();
        for r in 1 ... rows()
        {
            for c in 1 ... cols()
            {
                print(displayGrid[r-1][c-1], terminator: "")
            }
            print("")
        }
        
        // Write message, rat, and player info
        if msg != ""
        {
            print (msg)
        }
        print("There are ", ratCount(), " rats remaining.")
        if m_player == nil
        {
            print("There is no player!")
        }

        else if (m_player?.isDead())!
        {
            print("The player is dead.")
        }
        print(m_turns, " turns have been taken.")
    }
    
    public func setCellStatus(r: Int, c: Int, status: Int)
    {
        checkPos(r: r, c: c)
        m_grid[r-1][c-1] = status
    }
    
    public func addRat(r: Int, c: Int) -> Bool
    {
        guard isPosInBounds(r: r, c: c) else
        {
            return false
        }
            
        // Don't add a rat on a spot with a poison pellet
        if getCellStatus(r: r, c: c) != Globals.EMPTY
        {
            return false
        }
        
        // Don't add a rat on a spot with a player
        if m_player != nil  &&  m_player?.row() == r  &&  m_player?.col() == c
        {
            return false
        }
        
        if m_nRats == Globals.MAXRATS
        {
            return false
        }
        
        m_rats.append(Rat(ap: self, r: r, c: c))
        m_nRats += 1
        return true;
    }
    
    public func addPlayer(r: Int, c: Int) -> Bool
    {
        guard isPosInBounds(r: r, c: c) else
        {
            return false
        }
        
        // Don't add a player if one already exists
        if m_player != nil
        {
            return false
        }
        
        // Don't add a player on a spot with a rat
        if numberOfRatsAt(r: r, c: c) > 0
        {
            return false
        }
        
        m_player = Player(ap: self, r: r, c: c);
        return true;
    }
    
    public func moveRats()
    {
        var k = 0
        
        // Move all rats
        for rat in m_rats
        {
            rat.move()
            
            if m_player != nil  && rat.row() == m_player?.row()  &&  rat.col() == m_player?.col()
            {
                m_player?.setDead()
            }
        
            if rat.isDead()
            {
                
                m_rats.remove(at: k)
                
                // The order of Rat pointers in the m_rats array is
                // irrelevant, so it's easiest to move the last pointer to
                // replace the one pointing to the now-deleted rat.  Since
                // we are traversing the array from last to first, we know this
                // last pointer does not point to a dead rat.
                
                // Above comment is now meaningless (no pointers; and using a "vector")
                
                m_nRats -= 1
            }
            
            k += 1
        }
        
        // Another turn has been taken
        m_turns += 1
    }
    
    // Helper Functions
    
    private func isPosInBounds(r: Int, c: Int) -> Bool
    {
        return r >= 1  &&  r <= m_rows  &&  c >= 1  &&  c <= m_cols
    }
    
    private func checkPos(r: Int, c: Int)
    {
        if (!isPosInBounds(r: r, c: c))
        {
            print("***** Invalid arena position (", r, ", ", c, ")")
            exit(1);
        }
    }
    
    public func history() -> History
    {
        return m_history
    }
}
