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
import QtGraphicalEffects 1.0

Item {
    
    property double proportion
    
    property string valueLabel
    property string numberValue
    
    property bool fullCircle
    property bool showNumber
    property bool showLabel

    property int lineWidth: 1
    property bool fill: true
    
    property double circleOpacity: 1
    
    property double stdThickness: partSize/2.1
    property double circleThicknessAttr: fullCircle ? 0 : stdThickness * 0.9
    property double pi2: Math.PI * 2

    Layout.preferredWidth: partSize
    Layout.preferredHeight: partSize

    width: partSize
    height: partSize

    onProportionChanged: {
        repaint()
    }
    
    function repaint() {
        canvas.requestPaint()
    }
    
    Canvas {
        id: canvas

        property real alpha: 1.0

        // edge bleeding fix
        readonly property double filler: 0.01

        width: parent.width
        height: parent.height
        antialiasing: true
        opacity: circleOpacity * (fullCircle && mouseIn ? 0.5 : 1)

        onPaint: {
            var ctx = getContext('2d')
            ctx.clearRect(0, 0, canvas.width, canvas.height)
            ctx.fillStyle = theme.highlightColor
            ctx.strokeStyle = theme.highlightColor
            ctx.lineWidth = lineWidth

            var startRadian = - Math.PI / 2

            var radians = pi2 * proportion

            ctx.beginPath();
            ctx.arc(width/2, height/2, stdThickness, startRadian, startRadian + radians + filler, false)
            
            if(fill) {
                ctx.arc(width/2, height/2, circleThicknessAttr, startRadian + radians + filler, startRadian, true)
                ctx.closePath()
                ctx.fill()
            }
            else
                ctx.stroke()
        }
    }
    
    Text {
        id: valueText
        anchors.centerIn: parent
        text: numberValue
        font.pixelSize: fontPixelSize
        font.pointSize: -1
        color: theme.textColor
        visible: showNumber || mouseIn
    }
    
    DropShadow {
        anchors.fill: valueText
        radius: 3
        samples: 8
        spread: 0.8
        fast: true
        color: theme.backgroundColor
        source: valueText
        visible: showNumber || mouseIn
    }
    
    Text {
        id: valueTextLabel
        anchors.bottom: parent.bottom
        anchors.bottomMargin: -2
        anchors.right: parent.right
        text: valueLabel
        font.pixelSize: fontPixelSize * 0.65
        font.pointSize: -1
        color: theme.textColor
        visible: showLabel || mouseIn
    }
}
