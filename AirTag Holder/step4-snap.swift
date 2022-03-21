import SwiftSCAD

struct SnapInHolder: Shape3D {
    let tolerance = 0.25
    let layerThickness = 0.1
    let chamferSize = 1.2

    let airTagThickness = 7.98
    let airTagRadius = 15.935
    let airTagWidestPointZ = 4.17
    let airTagZeroZ = 0.88 // The Z level of the AirTag shape that corresponds to the holder's zero

    let holderWallThickness = 2.0
    var outerDiameter: Double { airTagRadius * 2 + holderWallThickness * 2 }

    let topExtension = 1.8
    var fullHeight: Double { airTagWidestPointZ - airTagZeroZ + topExtension }

    let splitDepth = 2.0
    let splitWidth = 13.0
    let splitCount = 3
    let splitSlopeLength = 2.0

    let loopThickness = 3.0
    let loopWidth = 4.0
    let loopCornerRadius = 5.0
    let loopInnerSize = Vector2D(4.0, 20.5)
    var loopOuterSize: Vector2D { loopInnerSize + [loopWidth, 2 * loopWidth] }

    var body: Geometry3D {
        Circle(diameter: outerDiameter)
            .extruded(height: fullHeight, chamferSize: chamferSize, method: .convexHull, sides: .both)
            .adding {
                // Loop
                let offset = Vector2D(outerDiameter / 2, 0)
                RoundedRectangle(loopOuterSize + offset, cornerRadius: loopCornerRadius, center: .y)
                    .subtracting {
                        RoundedRectangle(loopInnerSize + offset, cornerRadius: loopCornerRadius - loopWidth, center: .y)
                    }
                    .extruded(height: loopThickness, chamferSize: chamferSize, method: .layered(height: layerThickness), sides: .both)
            }
            .subtracting {
                airTagShape(tolerance: tolerance)
                    .translated(z: -airTagZeroZ)

                // Splits
                Rectangle([outerDiameter / 2 + 1, splitWidth], center: .y)
                    .extrudedHull(height: topExtension + 0.001) {
                        Rectangle([outerDiameter / 2 + 1, splitWidth + 2 * splitSlopeLength], center: .y)
                    }
                    .repeated(around: .z, in: 0°..<360°, count: splitCount)
                    .translated(z: fullHeight - topExtension)
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
}
