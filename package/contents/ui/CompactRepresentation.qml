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
import QtQuick.Controls 1.3

Item {
    id: compactRepresentation
    
    property bool fillIndicators
    property bool daysFullCircle
    property bool hoursFullCircle
    property bool minutesFullCircle
    property int strokeWidth

    property double parentWidth: Plasmoid.parent.width
    property double parentHeight: Plasmoid.parent.height
    
    property double numberOfParts: squareLayout ? 1 : (0 + (enableDays ? 1 : 0) + (enableHours ? 1 : 0) + (enableMinutes ? 1 : 0) + (enableSeconds ? 1 : 0))
    property double ratio: numberOfParts
    property double widgetWidth:  0
    property double widgetHeight: widgetWidth / numberOfParts

    onParentWidthChanged: setWidgetSize()
    onParentHeightChanged: setWidgetSize()

    onRatioChanged: setWidgetSize()

    function setWidgetSize() {
        if (!parentHeight) {
            return
        }
        var restrictToWidth = false
        if (planar) {
            restrictToWidth = (parentWidth / parentHeight) < ratio
        } else if (vertical) {
            restrictToWidth = true
        }
        widgetWidth = restrictToWidth ? parentWidth : parentHeight * numberOfParts
    }

    Component.onCompleted: setWidgetSize()

    property double partSize: squareLayout ? widgetHeight / 2 : widgetHeight
    property int seconds

    Layout.preferredWidth: widgetWidth
    Layout.preferredHeight: widgetHeight
    Layout.maximumHeight: widgetHeight

    property double fontPixelSize: partSize * 0.55
    
    property bool mouseIn: false
    
    Plasmoid.toolTipMainText: i18n('Uptime')
    Plasmoid.toolTipSubText: daysCircle.numberValue + ' days, ' + hoursCircle.numberValue + ':' + (minsCircle.numberValue >= 10 ? minsCircle.numberValue : '0' + minsCircle.numberValue)
    
    onDaysFullCircleChanged: daysCircle.repaint()
    onHoursFullCircleChanged: hoursCircle.repaint()
    onMinutesFullCircleChanged: minsCircle.repaint()
    onFillIndicatorsChanged: {
        daysCircle.repaint()
        hoursCircle.repaint()
        minsCircle.repaint()
        secsCircle.repaint()
    }
    onStrokeWidthChanged: {
        daysCircle.repaint()
        hoursCircle.repaint()
        minsCircle.repaint()
        secsCircle.repaint()
    }
    
    onSecondsChanged: {
        var secs = seconds
        var mins = 0
        if (secs >= 60) {
            mins = Math.floor(secs / 60)
            secs = secs - mins * 60
        }
        var hours = 0
        if (mins >= 60) {
            hours = Math.floor(mins / 60)
            mins = mins - hours * 60
        }
        var days = 0
        if (hours >= 24) {
            days = Math.floor(hours / 24)
            hours = hours - days * 24
        }
        
        daysCircle.proportion = days / 7
        daysCircle.numberValue = days
        
        hoursCircle.proportion = hours / 24
        hoursCircle.numberValue = hours
        
        minsCircle.proportion = mins / 60
        minsCircle.numberValue = mins
        
        secsCircle.proportion = secs / 60
        secsCircle.numberValue = secs
    }
    
    GridLayout {

        Layout.preferredWidth: widgetWidth
        Layout.preferredHeight: widgetHeight

        anchors.centerIn: parent
        
        columns: squareLayout ? 2 : 4
        columnSpacing: 0
        rowSpacing: 0
        
        CircleText {
            id: daysCircle
            valueLabel: 'd'
            fullCircle: daysFullCircle
            showNumber: daysShowNumber
            showLabel: daysShowLabel
            visible: enableDays
            fill: fillIndicators
            lineWidth: strokeWidth
        }
        
        CircleText {
            id: hoursCircle
            valueLabel: 'h'
            circleOpacity: 0.8
            fullCircle: hoursFullCircle
            showNumber: hoursShowNumber
            showLabel: hoursShowLabel
            visible: enableHours
            fill: fillIndicators
            lineWidth: strokeWidth
        }
        
        CircleText {
            id: minsCircle
            valueLabel: 'm'
            circleOpacity: 0.5
            fullCircle: minutesFullCircle
            showNumber: minutesShowNumber
            showLabel: minutesShowLabel
            visible: enableMinutes
            fill: fillIndicators
            lineWidth: strokeWidth
        }
        
        CircleText {
            id: secsCircle
            valueLabel: 's'
            circleOpacity: 0.2
            fullCircle: secondsFullCircle
            showNumber: secondsShowNumber
            showLabel: secondsShowLabel
            visible: enableSeconds
            fill: fillIndicators
            lineWidth: strokeWidth
        }
    }
    
    
    MouseArea {
        anchors.fill: parent
        
        hoverEnabled: true
        
        onEntered: {
            mouseIn = true
        }
        
        onExited: {
            mouseIn = false
        }
    }
    
}
