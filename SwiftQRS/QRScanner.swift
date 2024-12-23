//
//  QRScanner.swift
//  SwiftQRS
//
//  Created by Nihaal Sharma on 23/12/2024.
//

import SwiftUI
import AVFoundation

struct QRCodeScannerView: UIViewControllerRepresentable {
	func updateUIViewController(
		_ uiViewController: UIViewController,
		context: Context
	) {
		
	}

	class Coordinator: NSObject, AVCaptureMetadataOutputObjectsDelegate {
		var parent: QRCodeScannerView
		
		init(parent: QRCodeScannerView) {
			self.parent = parent
		}
		
		func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
			if let metadataObject = metadataObjects.first {
				guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
				guard let stringValue = readableObject.stringValue else { return }
				AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
				parent.didFindCode(stringValue)
			}
		}
	}
	var didFindCode: (String) -> Void
	

	func makeUIViewController(context: Context) -> UIViewController {
		let viewController = UIViewController()
		
		let captureSession = AVCaptureSession()
		
		guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return viewController }
		let videoDeviceInput: AVCaptureDeviceInput
		
		do {
			videoDeviceInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
		} catch {
			return viewController
		}
		
		if (captureSession.canAddInput(videoDeviceInput)) {
			captureSession.addInput(videoDeviceInput)
		} else {
			return viewController
		}
		
		let metadataOutput = AVCaptureMetadataOutput()
		
		if (captureSession.canAddOutput(metadataOutput)) {
			captureSession.addOutput(metadataOutput)
			
			metadataOutput.setMetadataObjectsDelegate(context.coordinator, queue: DispatchQueue.main)
			metadataOutput.metadataObjectTypes = [.qr]
		} else {
			return viewController
		}
		
		let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
		previewLayer.frame = viewController.view.bounds
		previewLayer.videoGravity = .resizeAspectFill
		viewController.view.layer.addSublayer(previewLayer)
		
		DispatchQueue.global(qos: .background).async {
			captureSession.startRunning()
			
			//			DispatchQueue.main.async {
			//				return viewController
			//			}
		}
		
		return viewController
	}
	
	func makeCoordinator() -> Coordinator {
		return Coordinator(parent: self)
	}
}
