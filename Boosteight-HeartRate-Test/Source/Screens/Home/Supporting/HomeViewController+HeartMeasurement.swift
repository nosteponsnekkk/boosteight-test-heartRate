//
//  HomeViewController+HeartMeasurement.swift
//  Boosteight-HeartRate-Test
//
//  Created by Oleg on 26.05.2024.
//

import UIKit
import AVFoundation
import CoreImage


extension HomeViewController {
    
    func initVideoCapture() {
        heartRateManager = makeHeartRateManager()
        heartRateManager?.startCapture()
        heartRateManager?.imageBufferHandler = { [weak self] (imageBuffer) in
            guard let self else { return }
            handle(buffer: imageBuffer)
        }
    }
    func deinitCaptureSession() {
        heartRateManager?.stopCapture()
        heartRateManager?.measurementStartedFlag = false
        heartRateManager?.imageBufferHandler = nil
        heartRateManager = nil
        toggleTorch(status: false)

    }
    private func makeHeartRateManager() -> HeartRateManager {
        let specs = VideoSpec(fps: 30, size: CGSize(width: 300, height: 300))
        let manager = HeartRateManager(cameraType: .back, preferredSpec: specs, previewContainer: measurmentView.previewLayer)
        manager.delegate = self
        return manager
    }
    
    private func startMeasurement(){
        guard let heartRateManager else { return }
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            heartRateManager.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { [weak self] (timer) in
                guard let self = self else { return }
                let average = heartRateManager.pulseDetector.getAverage()
                let pulse = 60.0/average
                if pulse == -60 {
                    // Wrong pulse
                    
                } else {
                    // Correct pulse
                    guard heartRateManager.bpms.count < 20 else { return }
                    currentBPM = pulse
                    heartRateManager.bpms.append(Int(pulse))
                }
            })
        }
        
    }
    
    private func toggleTorch(status: Bool) {
        guard let device = AVCaptureDevice.default(for: .video) else { return }
        device.toggleTorch(on: status)
    }
    
    private func handle(buffer: CMSampleBuffer) {
        toggleTorch(status: true)
        var redmean:CGFloat = 0.0;
        var greenmean:CGFloat = 0.0;
        var bluemean:CGFloat = 0.0;
        
        let pixelBuffer = CMSampleBufferGetImageBuffer(buffer)
        let cameraImage = CIImage(cvPixelBuffer: pixelBuffer!)
        
        let extent = cameraImage.extent
        let inputExtent = CIVector(x: extent.origin.x, y: extent.origin.y, z: extent.size.width, w: extent.size.height)
        let averageFilter = CIFilter(name: "CIAreaAverage",
                                     parameters: [kCIInputImageKey: cameraImage, kCIInputExtentKey: inputExtent])!
        let outputImage = averageFilter.outputImage!
        
        let ctx = CIContext(options:nil)
        let cgImage = ctx.createCGImage(outputImage, from:outputImage.extent)!
        
        let rawData:NSData = cgImage.dataProvider!.data!
        let pixels = rawData.bytes.assumingMemoryBound(to: UInt8.self)
        let bytes = UnsafeBufferPointer<UInt8>(start:pixels, count:rawData.length)
        var BGRA_index = 0
        for pixel in UnsafeBufferPointer(start: bytes.baseAddress, count: bytes.count) {
            switch BGRA_index {
            case 0:
                bluemean = CGFloat (pixel)
            case 1:
                greenmean = CGFloat (pixel)
            case 2:
                redmean = CGFloat (pixel)
            case 3:
                break
            default:
                break
            }
            BGRA_index += 1
        }
        
        let hsv = rgb2hsv((red: redmean, green: greenmean, blue: bluemean, alpha: 1.0))
        // Do a sanity check to see if a finger is placed over the camera
        if (hsv.1 > 0.5 && hsv.2 > 0.5) {
            guard let heartRateManager else { return }
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                measurmentView.state = .inProgress
                if !heartRateManager.measurementStartedFlag {
                    startMeasurement()
                    heartRateManager.measurementStartedFlag = true
                }
            }
            heartRateManager.validFrameCounter += 1
            heartRateManager.inputs.append(hsv.0)
            
            let filtered = heartRateManager.hueFilter.processValue(value: Double(hsv.0))
            if heartRateManager.validFrameCounter > 60 {
                heartRateManager.pulseDetector.addNewValue(newVal: filtered, atTime: CACurrentMediaTime())
            }
        } else {
            heartRateManager?.validFrameCounter = 0
            heartRateManager?.measurementStartedFlag = false
            heartRateManager?.pulseDetector.reset()
            heartRateManager?.bpms.removeAll()
            currentBPM = .zero
            DispatchQueue.main.async { [weak self] in
                self?.measurmentView.state = .initial
            }
        }
    }
    
}

