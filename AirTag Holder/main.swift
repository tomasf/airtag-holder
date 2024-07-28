import SwiftSCAD
import Foundation

save(to: "~/Desktop/airtag") {
    BasicShape()
        .named("basic shape")

    Sandwich()
        .named("sandwich")

    NutsAndBoltsHolder()
        .named("nutsandbolts")

    SnapInHolder()
        .named("snap")
}
