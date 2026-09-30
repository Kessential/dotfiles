/***************************************************************************
* Copyright (c) 2013 Abdurrahman AVCI <abdurrahmanavci@gmail.com>
* Copyright (c) 2024 Aleksei Bavshin <alebastr@fedoraproject.org>
*
* Permission is hereby granted, free of charge, to any person
* obtaining a copy of this software and associated documentation
* files (the "Software"), to deal in the Software without restriction,
* including without limitation the rights to use, copy, modify, merge,
* publish, distribute, sublicense, and/or sell copies of the Software,
* and to permit persons to whom the Software is furnished to do so,
* subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included
* in all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
* OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
* THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
* OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
* ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE
* OR OTHER DEALINGS IN THE SOFTWARE.
*
***************************************************************************/

import QtQuick 2.0
import SddmComponents 2.0

Rectangle {
    id: container
    width: 640
    height: 480

    LayoutMirroring.enabled: Qt.locale().textDirection == Qt.RightToLeft
    LayoutMirroring.childrenInherit: true

    property int sessionIndex: session.index

    TextConstants { id: textConstants }

    Connections {
        target: sddm

        function onLoginSucceeded() {
            errorMessage.color = "#89b4fa"
            errorMessage.text = textConstants.loginSucceeded
        }
        function onLoginFailed() {
            password.text = ""
            errorMessage.color = "#f38ba8"
            errorMessage.text = textConstants.loginFailed
        }
        function onInformationMessage(message) {
            errorMessage.color = "#f38ba8"
            errorMessage.text = message
        }
    }

    Background {
        anchors.fill: parent
        source: Qt.resolvedUrl(config.background)
        fillMode: Image.PreserveAspectCrop
        onStatusChanged: {
            var defaultBackground = Qt.resolvedUrl(config.defaultBackground)
            if (status == Image.Error && source != defaultBackground) {
                source = defaultBackground
            }
        }
    }

    Rectangle {
        anchors.fill: parent
        color: "transparent"
        //visible: primaryScreen

        // Custom clock (dd/MM/yyyy date instead of SddmComponents' Clock.qml
        // hardcoded Qt.DefaultLocaleLongDate).
        Column {
            id: clock
            anchors.margins: 5
            anchors.top: parent.top; anchors.right: parent.right

            property date dateTime: new Date()

            Timer {
                interval: 1000; running: true; repeat: true
                onTriggered: clock.dateTime = new Date()
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                color: "#cdd6f4"
                font.family: "Noto Sans Mono"
                font.pointSize: 72
                text: Qt.formatTime(clock.dateTime, "hh:mm")
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                color: "#a6adc8"
                font.pointSize: 24
                text: Qt.formatDate(clock.dateTime, "dd/MM/yyyy")
            }
        }

        Rectangle {
            id: rectangle
            anchors.centerIn: parent
            width: Math.max(320, mainColumn.implicitWidth + 50)
            height: Math.max(320, mainColumn.implicitHeight + 50)

            color: "#e61e1e2e"
            radius: 14
            border.width: 2
            border.color: "#b4befe"

            Column {
                id: mainColumn
                anchors.centerIn: parent
                spacing: 12
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: "#cdd6f4"
                    verticalAlignment: Text.AlignVCenter
                    height: text.implicitHeight
                    width: parent.width
                    text: textConstants.welcomeText.arg(sddm.hostName)
                    wrapMode: Text.WordWrap
                    font.pixelSize: 24
                    elide: Text.ElideRight
                    horizontalAlignment: Text.AlignHCenter
                }

                Column {
                    width: parent.width
                    spacing: 4
                    Text {
                        id: lblName
                        color: "#a6adc8"
                        width: parent.width
                        text: textConstants.userName
                        font.bold: true
                        font.pixelSize: 12
                    }

                    TextBox {
                        id: name
                        color: "#313244"
                        borderColor: "#45475a"
                        focusColor: "#b4befe"
                        hoverColor: "#89b4fa"
                        textColor: "#cdd6f4"
                        radius: 8
                        width: parent.width; height: 30
                        text: userModel.lastUser
                        font.pixelSize: 14

                        KeyNavigation.backtab: rebootButton; KeyNavigation.tab: password

                        Keys.onPressed: function (event) {
                            if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                                sddm.login(name.text, password.text, sessionIndex)
                                event.accepted = true
                            }
                        }
                    }
                }

                Column {
                    width: parent.width
                    spacing : 4
                    Text {
                        id: lblPassword
                        color: "#a6adc8"
                        width: parent.width
                        text: textConstants.password
                        font.bold: true
                        font.pixelSize: 12
                    }

                    PasswordBox {
                        id: password
                        color: "#313244"
                        borderColor: "#45475a"
                        focusColor: "#b4befe"
                        hoverColor: "#89b4fa"
                        textColor: "#cdd6f4"
                        radius: 8
                        width: parent.width; height: 30
                        font.pixelSize: 14

                        KeyNavigation.backtab: name; KeyNavigation.tab: session

                        Keys.onPressed: function (event) {
                            if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                                sddm.login(name.text, password.text, sessionIndex)
                                event.accepted = true
                            }
                        }
                    }
                }

                Row {
                    spacing: 4
                    width: parent.width / 2
                    z: 100

                    Column {
                        z: 100
                        width: parent.width * (layoutBox.visible ? 1.3 : 2)
                        spacing : 4
                        anchors.bottom: parent.bottom

                        Text {
                            id: lblSession
                            color: "#a6adc8"
                            width: parent.width
                            text: textConstants.session
                            wrapMode: TextEdit.WordWrap
                            font.bold: true
                            font.pixelSize: 12
                        }

                        ComboBox {
                            id: session
                            color: "#313244"
                            borderColor: "#45475a"
                            focusColor: "#b4befe"
                            hoverColor: "#89b4fa"
                            menuColor: "#313244"
                            textColor: "#cdd6f4"
                            arrowColor: "#313244"
                            width: parent.width; height: 30
                            font.pixelSize: 14

                            arrowIcon: Qt.resolvedUrl("angle-down.png")

                            model: sessionModel
                            index: sessionModel.lastIndex

                            KeyNavigation.backtab: password; KeyNavigation.tab: layoutBox
                        }
                    }

                    Column {
                        z: 101
                        width: parent.width * 0.7
                        spacing : 4
                        anchors.bottom: parent.bottom

                        visible: keyboard.enabled && keyboard.layouts.length > 0

                        Text {
                            id: lblLayout
                            color: "#a6adc8"
                            width: parent.width
                            text: textConstants.layout
                            wrapMode: TextEdit.WordWrap
                            font.bold: true
                            font.pixelSize: 12
                        }

                        LayoutBox {
                            id: layoutBox
                            color: "#313244"
                            borderColor: "#45475a"
                            focusColor: "#b4befe"
                            hoverColor: "#89b4fa"
                            menuColor: "#313244"
                            textColor: "#cdd6f4"
                            arrowColor: "#313244"
                            width: parent.width; height: 30
                            font.pixelSize: 14

                            arrowIcon: Qt.resolvedUrl("angle-down.png")

                            KeyNavigation.backtab: session; KeyNavigation.tab: loginButton
                        }
                    }
                }

                Column {
                    width: parent.width
                    Text {
                        id: errorMessage
                        color: "#a6adc8"
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: textConstants.prompt
                        font.pixelSize: 10
                    }
                }

                Row {
                    spacing: 4
                    anchors.horizontalCenter: parent.horizontalCenter
                    property int btnWidth: Math.max(loginButton.implicitWidth,
                                                    shutdownButton.implicitWidth,
                                                    rebootButton.implicitWidth, 80) + 8
                    Button {
                        id: loginButton
                        color: "#b4befe"
                        textColor: "#1e1e2e"
                        activeColor: "#cba6f7"
                        pressedColor: "#89b4fa"
                        radius: 8
                        text: textConstants.login
                        width: parent.btnWidth

                        onClicked: sddm.login(name.text, password.text, sessionIndex)

                        KeyNavigation.backtab: layoutBox; KeyNavigation.tab: shutdownButton
                    }

                    Button {
                        id: shutdownButton
                        color: "#313244"
                        textColor: "#cdd6f4"
                        activeColor: "#45475a"
                        pressedColor: "#585b70"
                        radius: 8
                        text: textConstants.shutdown
                        width: parent.btnWidth

                        onClicked: sddm.powerOff()

                        KeyNavigation.backtab: loginButton; KeyNavigation.tab: rebootButton
                    }

                    Button {
                        id: rebootButton
                        color: "#313244"
                        textColor: "#cdd6f4"
                        activeColor: "#45475a"
                        pressedColor: "#585b70"
                        radius: 8
                        text: textConstants.reboot
                        width: parent.btnWidth

                        onClicked: sddm.reboot()

                        KeyNavigation.backtab: shutdownButton; KeyNavigation.tab: name
                    }
                }
            }
        }
    }

    Component.onCompleted: {
        if (name.text == "")
            name.focus = true
        else
            password.focus = true
    }
}
