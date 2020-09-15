pragma Singleton

import QtQuick 2.12
import "../sccs" as Sccs
import "../projects" as Projects

Item {
    id: root

    // default user
    property string user: qsTr("Guest")

    // default routes
    property var defaultRoutes: [
        {
            name: qsTr("Welcome"),
            page: "../pages/WelcomePage.qml"
        },
        {
            name: qsTr("Continuous Deployment"),
            page: "../pages/ContinuousDeploymentPage.qml"
        },
        {
            name: qsTr("Continuous Deployment by Project"),
            page: "../pages/ContinuousDeploymentByProjectPage.qml"
        },
        {
            name: qsTr("Compliance Report"),
            page: "../pages/CompliancePage.qml"
        }
//        ,{
//            name: "Experimental",
//            page: "../pages/ExperimentalPage.qml"
//        }

    ]

    // default router
    property QtObject defaultRouter: null

    // languages supported
    property var languagesSupported: [
        qsTr("English"),
        qsTr("Français")
    ]

    // DevOps Sccs Plugin Settings
    property Sccs.PluginSettings sccs_plugin_settings: Sccs.PluginSettings {}

    // DevOps Project Settings
    property Projects.ProjectSettings projects_project_settings: Projects.ProjectSettings {}
    property var currentProject: undefined;
    property bool processing: true;

    /* POC

      Attempt to load on demand some subset of data shareable between multiple components (like redux/js)

      */

    // POC: Dynamic Loader for Repositories list
    StoreLoader {
        id: repos

        sourceAlt: "../sccs/Repositories.qml"
        parametersAlt: {"autoSend": false}
    }

    // POC: register/unregister functions to use Dynamic Loader feature
    function register(module) {
        console.log("register " + module)

        if (module === "repos") {
            return repos.use()
        } else {
            console.log(module + " not available !")
        }
    }

    function unregister(module) {
        console.log("unregister " + module)

        if (module === "repos") {
            repos.unuse()
        } else {
            console.log(module + " not available")
        }
    }
}
