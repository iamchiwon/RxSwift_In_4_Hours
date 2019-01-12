//
//  Common.swift
//  RxSwiftIn4Hours
//
//  Created by iamchiwon on 21/12/2018.
//  Copyright © 2018 n.code. All rights reserved.
//

import UIKit

let largeImageUrl = "https://picsum.photos/1024/768/?random"
let largerImageUrl = "https://picsum.photos/1280/720/?random"
let largestImageUrl = "https://picsum.photos/2560/1440/?random"

let loadingImageUrl = largerImageUrl

func syncLoadImage(from imageUrl: String) -> UIImage? {
    guard let url = URL(string: imageUrl) else { return nil }
    guard let data = try? Data(contentsOf: url) else { return nil }

    let image = UIImage(data: data)
    return image
}

func asyncLoadImage(from imageUrl: String, completed: @escaping (UIImage?) -> Void) {
    DispatchQueue.global().async {
        let image = syncLoadImage(from: imageUrl)
        completed(image)
    }
}
