//
//  RandomCatFactViewModel.swift
//  SystemTest
//
//  Created by Ramesh Maddali on 18/12/22.
//

import Reachability

class RandomCatFactViewModel: NSObject {
    
    private var apiService : APIService!
    
    private(set) var catFactData : RandomCatFact? {
        didSet {
            self.updateCatFactDataToReceliver()
        }
    }
    var updateCatFactDataToReceliver : (() -> ()) = {}
    
    private(set) var catImage : UIImage? {
        didSet {
            self.updateCatImageToReceiver()
        }
    }
    var updateCatImageToReceiver : (() -> ()) = {}
    
    override init() {
        super.init()
        self.apiService =  APIService()
    }
    
    func callAPIToGetCatFactData() {
        let paramsStr = ["count":1]
        self.apiService.getRandomCatFact(SERVICE_CATFACT_URL, paramsStr, GET_REQUEST) { data, error in
            self.catFactData = data
        }
    }
    
    func callAPITogetCatImage() {
        let randomNumber = getRandomNumber()
        let urlString = SERVICE_CATIMAGE_URL + "\(randomNumber)/\(randomNumber)"
        self.apiService.getRandomCatImage(urlString) { data, error in
            guard let data = data else { return }
            let image = UIImage(data: data)
            self.catImage = image
        }
    }
    
    private func getRandomNumber() -> Int {
        return  Int.random(in: 100..<800)
    }
}
