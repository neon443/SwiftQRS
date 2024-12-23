//
//  ContentView.swift
//  SwiftQRS
//
//  Created by Nihaal Sharma on 22/12/2024.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
	@State private var scannedCode: String?
	@State private var showScanner = false
	@State var savedQRs: [String] = []
	
	var body: some View {
		VStack {
			TabView {
				Tab("Scan", systemImage: "qrcode.viewfinder") {
					ZStack {
						VStack {
							if let qrData = scannedCode {
								Text("Scanned QR Code: \(qrData)")
									.padding()
									.clipShape(RoundedRectangle(cornerRadius: 5))
								HStack(spacing: 20) {
									Button {
										savedQRs.append(qrData)
									} label: {
										Image(systemName: "square.and.arrow.down")
											.resizable()
											.scaledToFit()
											.frame(width: 50, height: 50)
									}
									Button {
										scannedCode = nil
									} label: {
										Image(systemName: "trash")
											.resizable()
											.scaledToFit()
											.frame(width: 50, height: 50)
									}
								}
							}
						}
						Spacer()
						P161_Namespace(scannedCode: $scannedCode)
					}
				}
				
				Tab("Saved", systemImage: "list.bullet.clipboard") {
					SavedQRView(savedQRs: $savedQRs)
				}
			}
		}
	}
}



struct P161_Namespace: View {
	@Namespace private var namespace
	@State private var showDetail = true
	@State private var currentId: String = "background1"
	@Binding var scannedCode: String?
	
	var body: some View {
		VStack {
			if showDetail {
				Spacer()
				ZStack {
					RoundedRectangle(cornerRadius: 10)
						.fill(Color.blue)
						.matchedGeometryEffect(id: "background1", in: namespace)
					Image(systemName: "qrcode.viewfinder")
						.resizable()
						.scaledToFit()
						.frame(width: 40, height: 40)
						.padding()
						.matchedGeometryEffect(id: "title1", in: namespace)
				}
				.frame(width: 100, height: 50)
				.onTapGesture {
					currentId = "1"
				}
			} else {
				DetailView(
					namespace: namespace,
					id: currentId,
					scannedCode: $scannedCode
				)
			}
		}
		.padding()
		.simultaneousGesture(
			TapGesture()
				.onEnded { _ in
					DispatchQueue.main.async {
						withAnimation(.spring()) {
							showDetail.toggle()
						}
					}
				}
		)
		.onChange(of: scannedCode) {
			withAnimation(.spring()) {
				showDetail = false
			}
		}
	}
}

fileprivate
extension P161_Namespace {
	struct DetailView: View {
		let namespace: Namespace.ID
		let id: String
		@Binding var scannedCode: String?
		
		var body: some View {
			VStack {
				ZStack(alignment: .topLeading) {
					QRCodeScannerView { code in
						self.scannedCode = code
					}
					.matchedGeometryEffect(id: "background" + id, in: namespace)
					
					Image(systemName: "viewfinder")
						.padding()
						.imageScale(.large)
						.foregroundColor(Color.white)
						.padding()
						.matchedGeometryEffect(id: "title" + id, in: namespace)
				}
			}
		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
