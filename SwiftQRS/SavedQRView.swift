//
//  SavedQRView.swift
//  SwiftQRS
//
//  Created by Nihaal Sharma on 23/12/2024.
//

import SwiftUI

struct SavedQRView: View {
	@Binding var savedQRs: [String]
	
	var body: some View {
		NavigationView {
			List {
				ForEach(savedQRs, id: \.self) { qr in
					Text(qr)
				}
				.onDelete(perform: delete)
				.onMove(perform: move)
			}
			.navigationBarTitle("Saved QR Codes")
			.toolbar {
				ToolbarItem(placement: .topBarTrailing) {
					EditButton()
				}
			}
		}
	}
	
	func delete(at offsets: IndexSet) {
		savedQRs.remove(atOffsets: offsets)
	}
	
	func move(from source: IndexSet, to destination: Int) {
		savedQRs.move(fromOffsets: source, toOffset: destination)
	}
}

struct SavedQR_Preview: PreviewProvider {
	static var previews: some View {
		SavedQRView(savedQRs: .constant([
			"https://google.com",
			"https://github.com",
			"http://127.0.0.1",
			"http://localhost:8080"
		]))
	}
}
