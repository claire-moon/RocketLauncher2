/*  This file (main.cpp) is part of Rocket Launcher 2.0 - A cross platform
 *  front end for all DOOM engine source ports.
 *
 *  Copyright (C) Hypnotoad
 *
 *  Rocket Launcher is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  Rocket Launcher is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with Rocket Launcher.  If not, see <http://www.gnu.org/licenses/>.
 */

#include "rocketlauncher2.h"
#include <QApplication>
#include <QMessageBox>
#include <QtGlobal>

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);
    RocketLauncher2 w(0, argc, argv);

    /*
     * CI starts the complete application in Qt's offscreen platform mode.
     * Returning here verifies construction, settings, resources and plugin
     * loading without leaving an interactive window running indefinitely.
     */
    if (qEnvironmentVariableIsSet("ROCKETLAUNCHER2_SMOKE_TEST"))
        return 0;

    w.show();

    return a.exec();
}
