import SwiftSCAD
import Foundation

Project(root: "~/Desktop/airtag") {
    Product("basic shape") {
        BasicShape()
    }
    Product("sandwich") {
        Sandwich()
    }
    Product("nutsandbolts") {
        NutsAndBoltsHolder()
    }
    Product("snap") {
        SnapInHolder()
    }
}
.process()
