# qb-cyber

This job is an edited version of the qb-ifruitstore - This has custom items you can grab and sell for more profitable prices.

## This job is setup for Linden Outlaw Alerts.

## Images go into your qb-inventory or aj-inventory - html/images folder.


## This goes into your shared.lua

	['ps5'] 			 		     = {['name'] = 'ps5', 									['label'] = 'PS5 Console', 		   				['weight'] = 3000, 		['type'] = 'item', 		['image'] = 'ps5.png', 							['unique'] = false, 	['useable'] = false, 	['shouldClose'] = true,    ['combinable'] = nil,   ['description'] = 'PS5? You filthy casual!'},
	['ps2'] 			     		 = {['name'] = 'ps2', 									['label'] = 'PS2 Console', 		    			['weight'] = 3000, 		['type'] = 'item', 		['image'] = 'ps2.png', 							['unique'] = false, 	['useable'] = false, 	['shouldClose'] = true,    ['combinable'] = nil,   ['description'] = 'PS2? You filthy casual!'},
	['xboxx'] 			 			 = {['name'] = 'xboxx', 								['label'] = 'Xbox X Console', 		    		['weight'] = 3000, 		['type'] = 'item', 		['image'] = 'xboxx', 							['unique'] = false, 	['useable'] = false, 	['shouldClose'] = true,    ['combinable'] = nil,   ['description'] = 'Xbox X? You filthy casual!'},
	['gamecube'] 			         = {['name'] = 'gamecube', 					    		['label'] = 'Gamecube Console', 		    	['weight'] = 2200, 		['type'] = 'item', 		['image'] = 'gamecube.png', 					['unique'] = false, 	['useable'] = false, 	['shouldClose'] = true,    ['combinable'] = nil,   ['description'] = 'Super smash bros brawl anyone?'},
	['actionfigure'] 	 	         = {['name'] = 'actionfigure', 					    	['label'] = 'Action Figure', 					['weight'] = 1500, 		['type'] = 'item', 		['image'] = 'figure.png', 						['unique'] = false, 	['useable'] = false, 	['shouldClose'] = true,   ['combinable'] = nil,   ['description'] = 'A Minted looking action figure, still has the packaging..'},
	['awp'] 	 	             	 = {['name'] = 'awp', 					    			['label'] = 'AWP Replica', 						['weight'] = 4000, 		['type'] = 'item', 		['image'] = 'awp.png', 							['unique'] = false, 	['useable'] = false, 	['shouldClose'] = true,   ['combinable'] = nil,   ['description'] = 'A Replica AWP with some crazy looking paint job!'},

----------------------------------------

## This goes into your qb-pawnshop/server/main.lua - Example

<!-- local ItemListHardware = {
    ["tablet"] = math.random(50, 100),
    ["iphone"] = math.random(50, 200),
    ["samsungphone"] = math.random(75, 150),
    ["laptop"] = math.random(50, 200), -->
    ["ps5"] = math.random(300, 600),
    ["ps2"] = math.random(200, 250),
    ["xboxx"] = math.random(320, 650),
    ["gamecube"] = math.random(200, 325),
    ["actionfigure"] = math.random(400, 600),
    ["awp"] = math.random(170, 300),
<!-- } -->

----------------------------------------


# License

    QBCore Framework
    Copyright (C) 2021 Joshua Eger

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>

License is the same due to it being MADE FOR QBCore
