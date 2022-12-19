//
//  RandomCatFactViewController.swift
//  SystemTest
//
//  Created by Ramesh Maddali on 18/12/22.
//

import UIKit

class RandomCatFactViewController: UIViewController {
    
    @IBOutlet weak var catImageView: UIImageView!
    @IBOutlet weak var catfactTxtView: UITextView!
    private var activityView = UIActivityIndicatorView()
    private lazy var viewModel  = RandomCatFactViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Cat Fact"
        catImageView.layer.cornerRadius = 9.0
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedOnView))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGesture)
        getRandomCatImageAndFacts()
    }
    
    @objc func tappedOnView() {
        getRandomCatImageAndFacts()
    }
}

extension RandomCatFactViewController {
    func getRandomCatImageAndFacts() {
        if !NetworkReachability.shared.isNetworkAvailable() {
            Alert.presentationAlert(title: ALERT_TITLE, message: NO_INTERNET_ALERT, addButtons: [OK_TEXT], viewController: nil) { (alert, action) in
             }
            return
        }
        
        showLoader()

        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        
        viewModel.callAPIToGetCatFactData()
        viewModel.updateCatFactDataToReceliver = {
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        viewModel.callAPITogetCatImage()
        viewModel.updateCatImageToReceiver = {
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main, execute: {
            self.hideLoader()
            self.updateCatFact()
        }) 
    }

    func updateCatFact() {
        DispatchQueue.main.async { [weak self] in
            self?.catfactTxtView.text = self?.viewModel.catFactData?.data?.first
            self?.catImageView.image =  self?.viewModel.catImage
        }
    }
}

extension RandomCatFactViewController {
    func showLoader() {
        view.isUserInteractionEnabled = false
        activityView.style = .large
        activityView.color = .systemBlue
        activityView.center = view.center
        view.addSubview(activityView)
        activityView.startAnimating()
    }
    
    func hideLoader() {
        DispatchQueue.main.async {
            self.activityView.stopAnimating()
            self.activityView.removeFromSuperview()
            self.view.isUserInteractionEnabled = true
        }
    }
}
