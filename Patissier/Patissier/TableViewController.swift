//
//  TableViewController.swift
//  Patissier
//
//  Created by Francis Tseng on 2017/7/3.
//  Copyright © 2017年 Francis Tseng. All rights reserved.
//

import UIKit
import UILoadControl
import CoreData

class TableViewController: UIViewController, CommentManagerDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var addToCartOutlet: UIButton!
    @IBOutlet weak var commentTableView: UITableView!
    @IBOutlet weak var myTableView: UITableView!

    let commentManager = CommentManager()

    var productID = ""
    var productName = ""
    var productPrice = 0.0
    var comments = [ProductComment]()
    var userImageArray = [UIImage]()

    var favorites = [FavoriteMO]()

    override func viewDidLoad() {
        super.viewDidLoad()

        var colors = [UIColor]()
        colors.append(UIColor(red: 3/255, green: 63/255, blue: 122/255, alpha: 1))
        colors.append(UIColor(red: 4/255, green: 107/255, blue: 149/255, alpha: 1))
        navigationController?.navigationBar.setGradientBackground(colors: colors)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "Georgia-Bold", size: 18)!]
        self.navigationController?.navigationBar.layer.masksToBounds = false
        self.navigationController?.navigationBar.layer.shadowColor = UIColor(red: 53/255.0, green: 184/255.0, blue: 208/255.0, alpha: 0.85).cgColor
        self.navigationController?.navigationBar.layer.shadowOpacity = 1
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        self.navigationController?.navigationBar.layer.shadowRadius = 2

        let backBtn = UIBarButtonItem()
        let image: UIImage = UIImage(named: "icon-chervon.png")!
        backBtn.tintColor = UIColor.white
        backBtn.image = image
        backBtn.action = #selector(popSelf)
        backBtn.target = self
        navigationItem.leftBarButtonItem = backBtn

        commentManager.delegate = self

        self.commentManager.requestComments(productID: self.productID)

        commentTableView.separatorColor = UIColor(red: 165/255.0, green: 170/255.0, blue: 178/255.0, alpha: 1)

        addToCartOutlet.backgroundColor = UIColor(red: 4/255.0, green: 107/255.0, blue: 149/255.0, alpha: 1)
        addToCartOutlet.layer.cornerRadius = 2
        addToCartOutlet.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3).cgColor
        addToCartOutlet.layer.shadowOffset = CGSize(width: 0, height: 1)
        addToCartOutlet.layer.shadowRadius = 2
        addToCartOutlet.addTextSpacing(spacing: 0.2)
        addToCartOutlet.titleLabel?.shadowOffset = CGSize(width: -2.0, height: -2.0)
        addToCartOutlet.titleLabel?.font = UIFont(name: ".SFUIText-Semibold", size: 16)
        addToCartOutlet.tintColor = UIColor.white

        productNameLabel.text = productName
        productPriceLabel.text = "$ \(productPrice)"

        productImageView.downloadedFrom(link: "http://52.198.40.72/patissier/products/\(productID)/preview.jpg", contentMode: .scaleAspectFit)

        commentTableView.estimatedRowHeight = 68.0
        commentTableView.rowHeight = UITableViewAutomaticDimension

        myTableView.loadControl = UILoadControl(target: self, action: #selector(loadMore(sender:)))
        myTableView.loadControl?.heightLimit = 80.0

        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let request: NSFetchRequest<FavoriteMO> = FavoriteMO.fetchRequest()
            let context = appDelegate.persistentContainer.viewContext
            do {
                favorites = try context.fetch(request)
                print(favorites)
            } catch {
                print(error)
            }
        }
    }

    func popSelf() {
        navigationController?.popViewController(animated: true)
        // do your stuff if you needed
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCheckout" {
            let checkoutNavi = segue.destination as? UINavigationController
            let checkoutVC = checkoutNavi?.viewControllers.first as? CheckoutViewController
            checkoutVC?.productIDFromSegue = productID
            checkoutVC?.productNameFromSegue = productName
            checkoutVC?.productPriceFromSegue = productPrice
        }
        let backItem = UIBarButtonItem()
        backItem.title = ""
        backItem.tintColor = UIColor.white
        navigationItem.backBarButtonItem = backItem
    }

    func manager(_ manager: CommentManager, didGet products: [ProductComment]) {
        self.comments = products
        DispatchQueue.main.async {
            self.myTableView.reloadData()
        }
    }

    func manager(_ manager: CommentManager, didFailWith error: Error) {
        print(error)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }

    private func tableView(_ tableView: UITableView, didEndDisplaying cell: MyTableViewCell, forRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            cell.commenterImageView.image = nil
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "tableview_cell", for: indexPath) as? MyTableViewCell

        cell?.commenterImageView.image = nil

        cell?.commenterName.text = (comments[indexPath.item]).userName
        cell?.commenterName.font = UIFont(name: ".SFUIDisplay-Bold", size: 12)
        cell?.comment.text = (comments[indexPath.item]).text
        cell?.comment.font = UIFont(name: ".SFUIText-Medium", size: 12)
        cell?.comment.addTextSpacing()
        cell?.commenterImageView.downloadedFrom(link: "http://52.198.40.72/patissier/users/\(self.comments[indexPath.item].userID)/picture.jpg", contentMode: .scaleAspectFit)
        cell?.commenterImageView.layer.cornerRadius = (cell?.commenterImageView.frame.size.width)!/2
        cell?.commenterImageView.clipsToBounds = true

        return cell!
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        DispatchQueue.main.async {
            scrollView.loadControl?.update()
        }
    }

    func loadMore(sender: AnyObject?) {
        DispatchQueue.main.asyncAfter(deadline: (.now() + 2.0)) {
            self.commentManager.requestComments(productID: self.productID)
            self.myTableView.loadControl?.endLoading()
            self.myTableView.reloadData()

        }
    }
}
