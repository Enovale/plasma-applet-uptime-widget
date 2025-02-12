/*
 * Copyright 2015  Martin Kotelnik <clearmartin@seznam.cz>
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of
 * the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http: //www.gnu.org/licenses/>.
 */
import QtQuick 2.2
import QtQuick.Layouts 1.1
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore

Item {
    id: main
    
    anchors.fill: parent
    
    property bool vertical: (plasmoid.formFactor == PlasmaCore.Types.Vertical)
    property bool planar: (plasmoid.formFactor == PlasmaCore.Types.Planar)
    
    property bool inTray: (plasmoid.parent === null || plasmoid.parent.objectName === 'taskItemContainer')
    
    property bool squareLayout: inTray || plasmoid.configuration.squareLayout
    property bool fillIndicatorsSetting: plasmoid.configuration.fillIndicators
    property int strokeWidthSetting: plasmoid.configuration.strokeWidth
    
    property bool enableDays: plasmoid.configuration.enableDays
    property bool daysFullCircleSetting: plasmoid.configuration.daysFullCircle
    property bool daysShowNumber: plasmoid.configuration.daysShowNumber
    property bool daysShowLabel: plasmoid.configuration.daysShowLabel
    
    property bool enableHours: plasmoid.configuration.enableHours
    property bool hoursFullCircleSetting: plasmoid.configuration.hoursFullCircle
    property bool hoursShowNumber: plasmoid.configuration.hoursShowNumber
    property bool hoursShowLabel: plasmoid.configuration.hoursShowLabel
    
    property bool enableMinutes: plasmoid.configuration.enableMinutes
    property bool minutesFullCircleSetting: plasmoid.configuration.minutesFullCircle
    property bool minutesShowNumber: plasmoid.configuration.minutesShowNumber
    property bool minutesShowLabel: plasmoid.configuration.minutesShowLabel
    
    property bool enableSeconds: plasmoid.configuration.enableSeconds
    property bool secondsFullCircle: plasmoid.configuration.secondsFullCircle
    property bool secondsShowNumber: plasmoid.configuration.secondsShowNumber
    property bool secondsShowLabel: plasmoid.configuration.secondsShowLabel
    
    property int secondsValue: 0
    
    property Component cr: CompactRepresentation {
        seconds: secondsValue
        fillIndicators: fillIndicatorsSetting
        daysFullCircle: daysFullCircleSetting
        hoursFullCircle: hoursFullCircleSetting
        minutesFullCircle: minutesFullCircleSetting
        strokeWidth: strokeWidthSetting
    }

    Plasmoid.preferredRepresentation: Plasmoid.compactRepresentation
    Plasmoid.compactRepresentation: cr
    
    Component.onCompleted: {
        if (!inTray) {
            Plasmoid.fullRepresentation = cr
        }

        dataSource.exec('cat /proc/uptime')
    }
    
    PlasmaCore.DataSource {
        id: dataSource
        engine: 'executable'

        connectedSources: []

        function exec(cmd) {
            connectSource(cmd)
        }

        onNewData: {
            var value = data["stdout"];
            if (value === undefined || value == "") {
                return
            }
            secondsValue = Math.round(value.split(' ')[0])
        }
        interval: enableSeconds ? 1000 : 60000
    }
    
}
