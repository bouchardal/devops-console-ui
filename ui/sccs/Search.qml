import QtQuick 2.12
import QtQuick.Controls 2.12

import "../../backend/sccs" as Backend

//import "../../backend/core"

Item {
    id: root

    height: combobox.height

    property alias currentText: combobox.currentText

    Backend.Repositories {
        id: repos
    }

    ComboBox {
        id: combobox

        width: root.width
        model: repos.dataResponse

        textRole: "name"

        editable: true

        onAccepted: {
            if (find(editText) === -1) {
                console.log("nothing to do")
            }
        }
    }
}
