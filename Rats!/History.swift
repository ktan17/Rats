//
//  History.swift
//  Rats!
//
//  Created by Kevin Tan on 3/28/17.
//  Copyright © 2017 Caked Inc. All rights reserved.
//

import Foundation

class History
{
    private var m_nRows: Int
    private var m_nCols: Int
    private var m_grid:  Array<Array<Int>>
    
    init(nRows: Int, nCols: Int)
    {
        m_nRows = nRows
        m_nCols = nCols
        m_grid = Array(repeating: Array(repeating: Globals.EMPTY, count: nCols), count: nRows)
    }
    
    public func record(r: Int, c: Int) -> Bool
    {
        if r > m_nRows || r < 1 || c > m_nCols || c < 1
        {
            return false
        }
        else
        {
            m_grid[r-1][c-1] += 1
            return true
        }
    }
    
    public func display()
    {
        
        var displayGrid = [[Character]]()
        
        for i in 0 ... m_nRows-1
        {
            displayGrid.append(Array<Character>())
            for j in 0 ... m_nCols-1
            {
                if m_grid[i][j] != 0
                {
                    if m_grid[i][j] >= 26
                    {
                        displayGrid[i].append("Z")
                    }
                    else
                    {
                        let startingValue = Int(("A" as UnicodeScalar).value)
                        displayGrid[i].append(Character(UnicodeScalar(startingValue + m_grid[i][j] - 1)!))
                    }
                }
                else
                {
                    displayGrid[i].append(".")
                }
            }
        }
        
        // Draw the grid
        clearScreen()
        for i in 0 ... m_nRows-1
        {
            for j in 0 ... m_nCols-1
            {
                print(displayGrid[i][j], terminator: "")
            }
            print("")
        }
        
    }
    
}
