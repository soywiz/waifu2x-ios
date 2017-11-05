//
//  UIImage+RunModel.swift
//  waifu2x-ios
//
//  Created by xieyi on 2017/9/14.
//  Copyright © 2017年 xieyi. All rights reserved.
//

import Foundation
import UIKit
import CoreML

public enum Model {
    case anime_noise0
    case anime_noise1
    case anime_noise2
    case anime_noise3
    case anime_scale2x
    case anime_noise0_scale2x
    case anime_noise1_scale2x
    case anime_noise2_scale2x
    case anime_noise3_scale2x
    case photo_noise0
    case photo_noise1
    case photo_noise2
    case photo_noise3
    case photo_scale2x
    case photo_noise0_scale2x
    case photo_noise1_scale2x
    case photo_noise2_scale2x
    case photo_noise3_scale2x
}

extension UIImage {
    
    public func run(model: Model, scale: CGFloat = 1) -> UIImage? {
        let width = Int(self.size.width)
        let height = Int(self.size.height)
        switch model {
        case .anime_noise0, .anime_noise1, .anime_noise2, .anime_noise3, .photo_noise0, .photo_noise1, .photo_noise2, .photo_noise3:
            block_size = 128
        default:
            block_size = 142
        }
        let rects = getCropRects()
        let multis = getCroppedMultiArray(rects: rects)
        // Prepare for output array
        // Merge arrays into one array
        let normalize = { (input: Double) -> Double in
            let output = input * 255
            if output > 255 {
                return 255
            }
            if output < 0 {
                return 0
            }
            return output
        }
        let out_block_size = block_size * Int(scale)
        let out_width = width * Int(scale)
        let out_height = height * Int(scale)
        let bufferSize = out_block_size * out_block_size * 3
        var imgData = [UInt8].init(repeating: 0, count: out_width * out_height * 3)
        let pipeline = BackgroundPipeline<MLMultiArray>("merge_pipeline", count: rects.count) { (index, array) in
            autoreleasepool {
                let rect = rects[index]
                let origin_x = Int(rect.origin.x * scale)
                let origin_y = Int(rect.origin.y * scale)
                let dataPointer = UnsafeMutableBufferPointer(start: array.dataPointer.assumingMemoryBound(to: Double.self),
                                                             count: bufferSize)
                var dest_x: Int
                var dest_y: Int
                var src_index: Int
                var dest_index: Int
                for channel in 0..<3 {
                    for src_y in 0..<out_block_size {
                        for src_x in 0..<out_block_size {
                            dest_x = origin_x + src_x
                            dest_y = origin_y + src_y
                            src_index = src_y * out_block_size + src_x + out_block_size * out_block_size * channel
                            dest_index = (dest_y * out_width + dest_x) * 3 + channel
                            imgData[dest_index] = UInt8(normalize(dataPointer[src_index]))
                        }
                    }
                }
            }
        }
        // Run prediction on each block
        switch model {
        case .anime_noise0:
            let model = anime_noise0_model()
            for multi in multis {
                let result = try! model.prediction(input: multi)
                guard let resultArray = result.featureValue(for: "conv7")?.multiArrayValue else {
                    return nil
                }
                pipeline.appendObject(resultArray)
            }
        case .anime_noise1:
            let model = anime_noise1_model()
            for multi in multis {
                let result = try! model.prediction(input: multi)
                guard let resultArray = result.featureValue(for: "conv7")?.multiArrayValue else {
                    return nil
                }
                pipeline.appendObject(resultArray)
            }
        case .anime_noise2:
            let model = anime_noise2_model()
            for multi in multis {
                let result = try! model.prediction(input: multi)
                guard let resultArray = result.featureValue(for: "conv7")?.multiArrayValue else {
                    return nil
                }
                pipeline.appendObject(resultArray)
            }
        case .anime_noise3:
            let model = anime_noise3_model()
            for multi in multis {
                let result = try! model.prediction(input: multi)
                guard let resultArray = result.featureValue(for: "conv7")?.multiArrayValue else {
                    return nil
                }
                pipeline.appendObject(resultArray)
            }
        case .anime_scale2x:
            let model = up_anime_scale2x_model()
            for multi in multis {
                let result = try! model.prediction(input: multi)
                guard let resultArray = result.featureValue(for: "conv7")?.multiArrayValue else {
                    return nil
                }
                pipeline.appendObject(resultArray)
            }
        case .anime_noise0_scale2x:
            let model = up_anime_noise0_scale2x_model()
            for multi in multis {
                let result = try! model.prediction(input: multi)
                guard let resultArray = result.featureValue(for: "conv7")?.multiArrayValue else {
                    return nil
                }
                pipeline.appendObject(resultArray)
            }
        case .anime_noise1_scale2x:
            let model = up_anime_noise1_scale2x_model()
            for multi in multis {
                let result = try! model.prediction(input: multi)
                guard let resultArray = result.featureValue(for: "conv7")?.multiArrayValue else {
                    return nil
                }
                pipeline.appendObject(resultArray)
            }
        case .anime_noise2_scale2x:
            let model = up_anime_noise2_scale2x_model()
            for multi in multis {
                let result = try! model.prediction(input: multi)
                guard let resultArray = result.featureValue(for: "conv7")?.multiArrayValue else {
                    return nil
                }
                pipeline.appendObject(resultArray)
            }
        case .anime_noise3_scale2x:
            let model = up_anime_noise3_scale2x_model()
            for multi in multis {
                let result = try! model.prediction(input: multi)
                guard let resultArray = result.featureValue(for: "conv7")?.multiArrayValue else {
                    return nil
                }
                pipeline.appendObject(resultArray)
            }
        case .photo_noise0:
            let model = photo_noise0_model()
            for multi in multis {
                let result = try! model.prediction(input: multi)
                guard let resultArray = result.featureValue(for: "conv7")?.multiArrayValue else {
                    return nil
                }
                pipeline.appendObject(resultArray)
            }
        case .photo_noise1:
            let model = photo_noise1_model()
            for multi in multis {
                let result = try! model.prediction(input: multi)
                guard let resultArray = result.featureValue(for: "conv7")?.multiArrayValue else {
                    return nil
                }
                pipeline.appendObject(resultArray)
            }
        case .photo_noise2:
            let model = photo_noise2_model()
            for multi in multis {
                let result = try! model.prediction(input: multi)
                guard let resultArray = result.featureValue(for: "conv7")?.multiArrayValue else {
                    return nil
                }
                pipeline.appendObject(resultArray)
            }
        case .photo_noise3:
            let model = photo_noise3_model()
            for multi in multis {
                let result = try! model.prediction(input: multi)
                guard let resultArray = result.featureValue(for: "conv7")?.multiArrayValue else {
                    return nil
                }
                pipeline.appendObject(resultArray)
            }
        case .photo_scale2x:
            let model = up_photo_scale2x_model()
            for multi in multis {
                let result = try! model.prediction(input: multi)
                guard let resultArray = result.featureValue(for: "conv7")?.multiArrayValue else {
                    return nil
                }
                pipeline.appendObject(resultArray)
            }
        case .photo_noise0_scale2x:
            let model = up_photo_noise0_scale2x_model()
            for multi in multis {
                let result = try! model.prediction(input: multi)
                guard let resultArray = result.featureValue(for: "conv7")?.multiArrayValue else {
                    return nil
                }
                pipeline.appendObject(resultArray)
            }
        case .photo_noise1_scale2x:
            let model = up_photo_noise1_scale2x_model()
            for multi in multis {
                let result = try! model.prediction(input: multi)
                guard let resultArray = result.featureValue(for: "conv7")?.multiArrayValue else {
                    return nil
                }
                pipeline.appendObject(resultArray)
            }
        case .photo_noise2_scale2x:
            let model = up_photo_noise2_scale2x_model()
            for multi in multis {
                let result = try! model.prediction(input: multi)
                guard let resultArray = result.featureValue(for: "conv7")?.multiArrayValue else {
                    return nil
                }
                pipeline.appendObject(resultArray)
            }
        case .photo_noise3_scale2x:
            let model = up_photo_noise3_scale2x_model()
            for multi in multis {
                let result = try! model.prediction(input: multi)
                guard let resultArray = result.featureValue(for: "conv7")?.multiArrayValue else {
                    return nil
                }
                pipeline.appendObject(resultArray)
            }
        }
        pipeline.wait()
        let cfbuffer = CFDataCreate(nil, &imgData, out_width * out_height * 3)!
        let dataProvider = CGDataProvider(data: cfbuffer)!
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo.byteOrder32Big
        let cgImage = CGImage(width: out_width, height: out_height, bitsPerComponent: 8, bitsPerPixel: 24, bytesPerRow: out_width * 3, space: colorSpace, bitmapInfo: bitmapInfo, provider: dataProvider, decode: nil, shouldInterpolate: true, intent: CGColorRenderingIntent.defaultIntent)
        let outImage = UIImage(cgImage: cgImage!)
        return outImage
    }
    
}
