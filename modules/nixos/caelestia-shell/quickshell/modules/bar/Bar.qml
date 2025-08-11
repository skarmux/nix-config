import qs.widgets
import qs.services
import qs.config
import "popouts" as BarPopouts
import "components"
import "components/workspaces"
import Quickshell
import QtQuick

Item {
    id: root

    required property ShellScreen screen
    required property PersistentProperties visibilities
    required property BarPopouts.Wrapper popouts

    // Activate hover effects on mouse (x,y) hover detection
    // NOTE: This function is called from `drawer/Interactions.qml` when
    //       the cursor x-position is inside the Bar component (implicitWidth).
    // NOTE: `real` is a decimal type in QML
    // NOTE: Coordinate 0,0 is on the top-left (I think?)
    // TODO: Somehow the status icons and workspace icons only appear
    //       after the mouse has hovered over the status area once.
    // TODO: When leaving the popout to the right, it does not automatically close.
    function checkPopout(y: real): void {

        // ActiveWindow
        //
        // const aw = activeWindow.child;
        // const awy = activeWindow.y + aw.y;
        // if (y >= awy && y <= awy + aw.implicitHeight) {
            // popouts.currentName = "activewindow";
            // popouts.currentCenter = Qt.binding(() => activeWindow.y + aw.y + aw.implicitHeight / 2);
            // popouts.hasCurrent = true;
        // } else

        // Tray
        //
        if (y > tray.y && y < (tray.y + tray.implicitHeight)) {
            // Calculate which tray item is hovered
            const index = Math.floor(((y - tray.y) / tray.implicitHeight) * tray.items.count);
            const item = tray.items.itemAt(index);

            popouts.currentName = `traymenu${index}`;
            popouts.currentCenter = Qt.binding(() => tray.y + item.y + item.implicitHeight / 2);
            popouts.hasCurrent = true;
            return;
        }

        // Status Icons
        //
        // NOTE: It appears to have builtin hover action on its child elements
        for (const area of statusIconsInner.hoverAreas) {
            if (!area.enabled)
                continue;

            const item = area.item;
            const spacing = Appearance.spacing.small;

            // TODO: Double check the size. I prefer the collision box to be as large as possible within the bounds of Bar
            //       Also: Adding some parentheses maybe?
            const iy = statusIcons.y + statusIconsInner.y + item.y - spacing / 2; 

            // Check if mouse position is within area
            if (y > iy && y <= (iy + item.implicitHeight + spacing)) {
                popouts.currentName = area.name;
                popouts.currentCenter = Qt.binding(() => statusIcons.y + statusIconsInner.y + item.y + item.implicitHeight / 2);
                popouts.hasCurrent = true;
                return;
            }
        }

        // No bar element is hovered
        popouts.hasCurrent = false;
    }

    anchors.top: parent.top
    anchors.bottom: parent.bottom
    anchors.left: parent.left

    implicitWidth: child.implicitWidth + Config.border.thickness * 2

    Item {
        id: child

        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter

        implicitWidth: Math.max(workspaces.implicitWidth, tray.implicitWidth, statusIcons.implicitWidth)

        // OsIcon {
        //     id: osIcon
        //     anchors.horizontalCenter: parent.horizontalCenter
        //     anchors.top: parent.top
        //     anchors.topMargin: Appearance.padding.large
        // }

        // ActiveWindow {
        //     id: activeWindow
        //     anchors.horizontalCenter: parent.horizontalCenter
        //     anchors.top: osIcon.bottom
        //     anchors.bottom: workspaces.top
        //     anchors.margins: Appearance.spacing.large
        //     monitor: Brightness.getMonitorForScreen(root.screen)
        // }

        StyledRect {
            id: workspaces

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: Appearance.padding.large
            // anchors.bottomMargin: Appearance.padding.large
            // anchors.bottom: tray.top

            radius: Appearance.rounding.full
            // color: Colours.palette.m3surfaceContainer

            implicitWidth: workspacesInner.implicitWidth + Appearance.padding.small * 2
            implicitHeight: workspacesInner.implicitHeight + Appearance.padding.small * 2

            CustomMouseArea {
                anchors.fill: parent
                anchors.leftMargin: -Config.border.thickness
                anchors.rightMargin: -Config.border.thickness

                // Switch workspaces on mouse scroll
                function onWheel(event: WheelEvent): void {
                    const activeWs = Hyprland.activeToplevel?.workspace?.name;
                    if (activeWs?.startsWith("special:"))
                        Hyprland.dispatch(`togglespecialworkspace ${activeWs.slice(8)}`);
                    else if (event.angleDelta.y < 0 || Hyprland.activeWsId > 1)
                        Hyprland.dispatch(`workspace r${event.angleDelta.y > 0 ? "-" : "+"}1`);
                }
            }

            Workspaces {
                id: workspacesInner

                anchors.centerIn: parent
            }
        }

        // TODO: Switch to corresponding workspace when selecting `Open xyz`
        Tray {
            id: tray

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: statusIcons.top
            anchors.bottomMargin: Appearance.spacing.larger
        }

        // Clock {
        //     id: clock
        //     anchors.horizontalCenter: parent.horizontalCenter
        //     anchors.bottom: statusIcons.top
        //     anchors.bottomMargin: Appearance.spacing.normal
        // }

        // Wifi, Bluetooth, Power-Management
        // FIXME: Crashes when a Bluetooth device (forcefully) disconnects.
        StyledRect {
            id: statusIcons
            // TODO: Why do I need anchors left/right here but not at the others?
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.bottomMargin: Appearance.spacing.normal
            // radius: Appearance.rounding.full
            // color: Colours.palette.m3surfaceContainer
            implicitHeight: statusIconsInner.implicitHeight + Appearance.padding.normal * 2
            StatusIcons {
                id: statusIconsInner
                anchors.centerIn: parent
            }
        }

        // Power {
        //     id: power
        //     anchors.horizontalCenter: parent.horizontalCenter
        //     anchors.bottom: parent.bottom
        //     anchors.bottomMargin: Appearance.padding.large
        //     visibilities: root.visibilities
        // }
    }
}
