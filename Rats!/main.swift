//
//  main.swift
//  Rats!
//
//  Created by Kevin Tan on 3/27/17.
//  Copyright © 2017 Caked Inc. All rights reserved.
//

import Foundation

// Create a game
// Use this instead to create a mini-game:   Game g(3, 5, 2);
var g = Game(rows: 10, cols: 12, nRats: 10)

// Play the game
g.play()
