//#define LOWMEMORYMODE //uncomment this to load just titlescreen and runtime town

#include "map_files\generic\titlescreen.dmm"
// #include "map_files\Mining\Lavaland.dmm"

#ifndef LOWMEMORYMODE
	#ifdef ALL_MAPS
<<<<<<< HEAD
		#include "map_files\Vampire\runtimetown.dmm"
		#include "map_files\Vampire\SanFrancisco.dmm"
=======
		#include "map_files\Birdshot\birdshot.dmm"
		#include "map_files\debug\multiz.dmm"
		#include "map_files\debug\runtimestation.dmm"
		#include "map_files\Deltastation\DeltaStation2.dmm"
		#include "map_files\IceBoxStation\IceBoxStation.dmm"
		#include "map_files\MetaStation\MetaStation.dmm"
		#include "map_files\Mining\Lavaland.dmm"
		#include "map_files\NorthStar\north_star.dmm"
		#include "map_files\tramstation\tramstation.dmm"
		#include "map_files\wawastation\wawastation.dmm"

>>>>>>> d1ccb530b21a3c41ef5ec37ef5f9330d6e562441
		#ifdef CIBUILDING
			#include "templates.dm"
		#endif
	#endif
#endif
