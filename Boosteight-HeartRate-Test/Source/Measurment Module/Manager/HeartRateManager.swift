//
//  HeartRateManager.swift
//  Boosteight-HeartRate-Test
//
//  Created by Oleg on 26.05.2024.
//

import Foundation
import AVFoundation

public protocol HeartManagmentDelegate: AnyObject {
    func didCompleteRating(heartRate bpm: Int?)
    func getProgress(progress: CGFloat)
}

enum CameraType: Int {
    case back
    case front
    
    func captureDevice() -> AVCaptureDevice {
        switch self {
        case .front:
            let devices = AVCaptureDevice.DiscoverySession(deviceTypes: [], mediaType: AVMediaType.video, position: .front).devices
            print("devices:\(devices)")
            for device in devices where device.position == .front {
                return device
            }
        default:
            break
        }
        return AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)!
    }
}

struct VideoSpec {
    var fps: Int32?
    var size: CGSize?
}

typealias ImageBufferHandler = ((_ imageBuffer: CMSampleBuffer) -> ())

class HeartRateManager: NSObject {
    
    weak var delegate: HeartManagmentDelegate?
    var bpms: [Int] = [] {
        didSet {
            if bpms.count >= 20 {
                delegate?.didCompleteRating(heartRate: bpms.averageOfThreeMostFrequent())
                delegate = nil
                bpms.removeAll()
            } else {
                delegate?.getProgress(progress: CGFloat(bpms.count)/CGFloat(20))
            }
        }
    }
    var measurementStartedFlag = false
    var pulseDetector = PulseDetector()
    var timer = Timer()
    var validFrameCounter = 0
    var inputs: [CGFloat] = []
    var hueFilter = Filter()

    private let captureSession = AVCaptureSession()
    private var videoDevice: AVCaptureDevice!
    private var videoConnection: AVCaptureConnection!
    private var audioConnection: AVCaptureConnection!
    private var previewLayer: AVCaptureVideoPreviewLayer?
    
    var imageBufferHandler: ImageBufferHandler?
    
    init(cameraType: CameraType, preferredSpec: VideoSpec?, previewContainer: CALayer?) {
        super.init()
        print("Heart rate manager has been initialized")

        videoDevice = cameraType.captureDevice()
        
        // MARK: - Setup Video Format
        do {
            captureSession.sessionPreset = .low
            if let preferredSpec = preferredSpec {
                // Update the format with a preferred fps
                videoDevice.updateFormatWithPreferredVideoSpec(preferredSpec: preferredSpec)
            }
        }
        
        // MARK: - Setup video device input
        let videoDeviceInput: AVCaptureDeviceInput
        do {
            videoDeviceInput = try AVCaptureDeviceInput(device: videoDevice)
        } catch let error {
            fatalError("Could not create AVCaptureDeviceInput instance with error: \(error).")
        }
        guard captureSession.canAddInput(videoDeviceInput) else { fatalError() }
        captureSession.addInput(videoDeviceInput)
 
        // MARK: - Setup preview layer
        if let previewContainer = previewContainer {
            let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            previewLayer.frame = previewContainer.bounds
            previewLayer.contentsGravity = CALayerContentsGravity.resizeAspectFill
            previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            previewContainer.insertSublayer(previewLayer, at: 0)
            self.previewLayer = previewLayer
        }
        
        // MARK: - Setup video output
        let videoDataOutput = AVCaptureVideoDataOutput()
        videoDataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey : NSNumber(value: kCVPixelFormatType_32BGRA)] as [String : Any]
        videoDataOutput.alwaysDiscardsLateVideoFrames = true
        let queue = DispatchQueue(label: "com.covidsense.videosamplequeue")
        videoDataOutput.setSampleBufferDelegate(self, queue: queue)
        guard captureSession.canAddOutput(videoDataOutput) else {
            fatalError()
        }
        captureSession.addOutput(videoDataOutput)
        videoConnection = videoDataOutput.connection(with: .video)
    }
    deinit {
        print("Heart rate manager has been de-initialized")
    }
    
    func startCapture() {
        #if DEBUG
        print(#function + "\(self.classForCoder)/")
        #endif
        if captureSession.isRunning {
            #if DEBUG
            print("Capture Session is already running 🏃‍♂️.")
            #endif
            return
        }
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.captureSession.startRunning()
        }
    }
    
    func stopCapture() {
        #if DEBUG
        print(#function + "\(self.classForCoder)/")
        #endif
        if !captureSession.isRunning {
            #if DEBUG
            print("Capture Session has already stopped 🛑.")
            #endif
            return
        }
        captureSession.stopRunning()
    }
}

extension HeartRateManager: AVCaptureVideoDataOutputSampleBufferDelegate {
    // MARK: - Export buffer from video frame
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        if connection.videoOrientation != .portrait {
            connection.videoOrientation = .portrait
            return
        }
        if let imageBufferHandler = imageBufferHandler {
            imageBufferHandler(sampleBuffer)
        }
    }
}
