/*
IntWars playground server for League of Legends protocol testing
Copyright (C) 2012  Intline9 <Intline9@gmail.com>

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#include "stdafx.h"
#include "Config.h"
#include "Game.h"
#include "RAFManager.h"
#include "Inibin.h"
#include "ItemManager.h"
#include "Logger.h"
#include "Pathfinder.h"

#define SERVER_HOST ENET_HOST_ANY

#define SERVER_VERSION "0.2.0"

int main(int argc, char ** argv)
{
	printf("Yorick %s\n", SERVER_VERSION);

if (argc == 3)
{
	Config::instance().setluaconfig(argv[1]);
	Config::instance().setfilearchivesPath(argv[2]);
}

	/* Load Port and Server Key */
	LuaScript script(false);
	script.loadScript(Config::instance().getluaconfig());
	sol::table config = script.getTable("game");
	int SERVER_PORT = config.get<int>("port");
  std::string SERVER_KEY = config.get<std::string>("server_key");

	std::cout << SERVER_PORT << std::endl;
	std::cout << SERVER_KEY << std::endl;

	std::cout << "CONFIG_LUA = " << Config::instance().getluaconfig() <<std::endl;
	std::cout << "FILEARCHIVES_PATH = " << Config::instance().getfilearchivesPath() <<std::endl;

	Logger::instance().setLogFile("../../log.html", false, true);
	CORE_INFO("Loading RAF files in filearchives/.");

   std::string basePath = RAFManager::getInstance()->findGameBasePath();

   if(!RAFManager::getInstance()->init(Config::instance().getfilearchivesPath())) {
      CORE_ERROR("Couldn't load RAF files. Make sure you have a 'filearchives' directory in the server's root directory. This directory is to be taken from RADS/projects/lol_game_client/");
      return EXIT_FAILURE;
		}

   ItemManager::getInstance()->init();

   CORE_INFO("Game started");

	Game g;
	ENetAddress address;
	address.host = SERVER_HOST;
	address.port = SERVER_PORT;

   if (!g.initialize(&address, SERVER_KEY.c_str())) {
      CORE_ERROR("Couldn't listen on port %d, or invalid key", SERVER_PORT);
	    return EXIT_FAILURE;
   }

	g.netLoop();

   PathNode::DestroyTable(); // Cleanup
   return EXIT_SUCCESS;
}
