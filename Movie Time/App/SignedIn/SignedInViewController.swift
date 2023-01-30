//
//  SignedInViewController.swift
//  Movie Time
//
//  Created by Arpit Singh on 30/01/23.
//

import UIKit

class SignedInViewController: UIViewController {
    
    private let session: UserSession
    private let movieRemoteApi: MovieListRemoteAPI
    
    init(session: UserSession,
         movieRemoteApi: MovieListRemoteAPI) {
        self.session = session
        self.movieRemoteApi = movieRemoteApi
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        // Do any additional setup after loading the view.
    }
    

}
