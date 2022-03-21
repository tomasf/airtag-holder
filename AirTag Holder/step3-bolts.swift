import SwiftSCAD

struct NutsAndBoltsHolder: Shape3D {
    let airTagThickness = 7.98
    let airTagRadius = 15.935
    let airTagWidestPointZ = 4.17

    var thickness: Double { airTagWidestPointZ + 0.4 }
    let boxTagTolerance = 0.15

    let shapeCornerSize = 11.0
    var holeOffset: Double { airTagRadius + shapeCornerSize / 2 + 1.5 }
    let holeDiameter = 3.0 + 0.6

    let squareNutWidth = 5.4 + 0.3
    let squareNutThickness = 1.8
    let squareNutTrapExtraDepth = 1.2

    let countersunkBoltHeadTopDiameter = 5.8 + 0.6
    let countersunkBoltHeadHeight = 2.0

    let layerThickness = 0.1

    var body: Geometry3D {
        bottomHalf()
            .rotated(z: 60°)
            .adding {
                topHalf()
                    .translated(x: 40)
            }
    }

    private func airTagShape(tolerance: Double) -> Geometry3D {
        let shapePoints: [Vector2D] = [[15.935, 7.98], [15.93, 7.97], [15.10, 7.96], [14.27, 7.95], [13.44, 7.95], [12.61, 7.92], [11.78, 7.89], [10.96, 7.85], [10.13, 7.81], [9.30, 7.75], [8.48, 7.69], [7.65, 7.62], [6.83, 7.54], [6.00, 7.44], [5.18, 7.33], [4.36, 7.20], [3.55, 7.03], [2.75, 6.82], [1.97, 6.55], [1.23, 6.18], [0.58, 5.67], [0.13, 4.98], [0.00, 4.17], [0.24, 3.38], [0.77, 2.75], [1.46, 2.29], [3.21, 2.29], [3.21, 0.88], [4.18, 0.75], [5.16, 0.63], [6.13, 0.52], [7.11, 0.42], [8.09, 0.33], [9.07, 0.26], [10.04, 0.19], [11.02, 0.13], [12.00, 0.08], [12.98, 0.05], [13.97, 0.02], [14.95, 0.01], [15.93, 0.00]]

        return Polygon(shapePoints)
            .translated(x: -airTagRadius - tolerance)
            .adding {
                Rectangle([tolerance + 0.01, airTagThickness])
                    .translated(x: -tolerance - 0.01)
            }
            .extruded(angles: 0°..<360°)
    }

    private func half() -> Geometry3D {
        Circle(diameter: shapeCornerSize)
            .translated(x: holeOffset)
            .repeated(in: 0°..<360°, count: 3)
            .convexHull()
            .subtracting {
                Circle(diameter: holeDiameter)
                    .translated(x: holeOffset)
                    .repeated(in: 0°..<360°, count: 3)
            }
            .extruded(height: thickness)
    }

    private func nutTrap() -> Geometry3D {
        Box([squareNutWidth, squareNutWidth, squareNutThickness + squareNutTrapExtraDepth], center: .xy)
            .adding {
                // Bridging trick to deal with overhang for nut traps
                Box([squareNutWidth, holeDiameter, layerThickness], center: .xy)
                    .translated(z: squareNutThickness + squareNutTrapExtraDepth)
            }
    }

    private func bottomHalf() -> Geometry3D {
        half()
            .subtracting {
                airTagShape(tolerance: boxTagTolerance)
                    .translated(z: thickness - airTagWidestPointZ)
                nutTrap()
                    .translated(x: holeOffset, z: -0.01)
                    .repeated(around: .z, in: 0°..<360°, count: 3)
            }
    }

    private func topHalf() -> Geometry3D {
        half()
            .subtracting {
                airTagShape(tolerance: boxTagTolerance)
                    .rotated(x: 180°)
                    .translated(z: thickness + airTagWidestPointZ)

                Cylinder(bottomDiameter: countersunkBoltHeadTopDiameter, topDiameter: holeDiameter, height: countersunkBoltHeadHeight)
                    .translated(x: holeOffset, z: -0.01)
                    .repeated(around: .z, in: 0°..<360°, count: 3)
            }
    }
}
