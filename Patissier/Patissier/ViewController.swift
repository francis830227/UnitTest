//
//  ViewController.swift
//  Patissier
//
//  Created by Francis Tseng on 2017/6/21.
//  Copyright © 2017年 Francis Tseng. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import UILoadControl
import CoreData

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ProductManagerDelegate, UIScrollViewDelegate {

    @IBOutlet weak var myCollectionView: UICollectionView!

    let productManager = ProductManager()
    var products = [Product]()
    var imageArray = [UIImage]()
    var productID = ""
    var productName = ""
    var productPrice = 0.0

    var coreDataID = ""

    var favorite: FavoriteMO!

    var favorites = [FavoriteMO]()
    //swiftlint:disable force_cast
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //swiftlint:enable force_cast

       override func viewDidLoad() {
        super.viewDidLoad()

        productManager.delegate = self
        productManager.requestProducts()

        //gradient navigationBar
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

        //        第一次登入後可取得使用者token，後續即可直接登入
        if (FBSDKAccessToken.current()) != nil {
            //            fetchProfile()
        }

        let flowLayout = UICollectionViewFlowLayout.init()

        flowLayout.minimumLineSpacing = 25

        flowLayout.minimumInteritemSpacing = 25

        flowLayout.sectionInset = UIEdgeInsets.init(top: 24, left: 20, bottom: 10, right: 20)

        myCollectionView.collectionViewLayout = flowLayout

        myCollectionView.delegate = self

        myCollectionView.dataSource = self

        myCollectionView.loadControl = UILoadControl(target: self, action: #selector(loadMore(sender:)))
        myCollectionView.loadControl?.heightLimit = 80.0
    }

    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
            myCollectionView.reloadData()

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toTableView" {
            let destinationViewController = segue.destination as? TableViewController

            let cell = sender as? MyCollectionViewCell

            for product in products where cell?.productName.text == product.name {
                    productID = product.id
                    productName = product.name
                    productPrice = product.price
            }
            destinationViewController?.productID = productID
            destinationViewController?.productName = productName
            destinationViewController?.productPrice = productPrice
        }

    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collection_cell", for: indexPath) as? MyCollectionViewCell

        cell?.productImage.image = nil

        //Font
        cell?.productName.font = UIFont.asiTextStyle5Font()
        cell?.productPrice.font = UIFont.asiTextStyle6Font()

        //Image

        if imageArray.count > indexPath.row {
            cell?.productImage.image = imageArray[indexPath.row]
        }

        //background shadow
        cell?.backgroundShadow.layer.shadowColor = UIColor.black.cgColor
        cell?.backgroundShadow.layer.shadowOpacity = 0.26
        cell?.backgroundShadow.layer.shadowOffset = CGSize(width: 0, height: 1)
        cell?.backgroundShadow.layer.shadowRadius = 1

        //bottom style
        cell?.bottom.clipsToBounds = true
        cell?.bottom.layer.masksToBounds = true
        cell?.bottom.layer.cornerRadius = 1
        cell?.bottom.layer.borderWidth = 0.2
        cell?.bottom.layer.borderColor = UIColor(red: 165/255.0, green: 170/255.0, blue: 178/255.0, alpha: 1.0).cgColor

        //like style
        cell?.like.tintColor = UIColor(red: 165/255.0, green: 170/255.0, blue: 178/255.0, alpha: 1.0)
        cell?.like.layer.borderColor = UIColor(red: 165/255.0, green: 170/255.0, blue: 178/255.0, alpha: 1.0).cgColor

        for item in favorites where products[indexPath.item].name == item.name {
            cell?.like.tintColor = UIColor(red: 255/255.0, green: 53/255.0, blue: 71/255.0, alpha: 1)
            cell?.like.layer.borderColor = UIColor(red: 255/255.0, green: 53/255.0, blue: 71/255.0, alpha: 1).cgColor
        }

        cell?.like.clipsToBounds = true
        cell?.like.layer.masksToBounds = true
        cell?.like.layer.cornerRadius = 4
        cell?.like.layer.borderWidth = 0.2
        cell?.like.addTarget(self, action: #selector(saveToCoreData), for: .touchUpInside)
        cell?.like.tag = indexPath.row
        cell?.productName.text = products[indexPath.item].name
        cell?.productPrice.text = "$ \(products[indexPath.item].price)"

        return cell!
    }

    func saveToCoreData(sender: UIButton) {

        if sender.tintColor == UIColor(red: 165/255.0, green: 170/255.0, blue: 178/255.0, alpha: 1.0) {
            sender.tintColor = UIColor(red: 255/255.0, green: 53/255.0, blue: 71/255.0, alpha: 1)
            sender.layer.borderColor = UIColor(red: 255/255.0, green: 53/255.0, blue: 71/255.0, alpha: 1).cgColor

            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                favorite = FavoriteMO(context: appDelegate.persistentContainer.viewContext)
                favorite.id = products[sender.tag].id
                favorite.name = products[sender.tag].name
                favorite.price = products[sender.tag].price
                favorite.like = true
                coreDataID = favorite.id!

                if sender.tag < imageArray.count {
                    let favoriteImage = UIImageJPEGRepresentation(imageArray[sender.tag], 1)
                    self.favorite.image = favoriteImage! as NSData
                    print("save \(favorite.name ?? "no favoriteName")")

                    appDelegate.saveContext()
                }
                do {
                    let tasks = try self.context.fetch(FavoriteMO.fetchRequest())

                    favorites = (tasks as? [FavoriteMO])!
                    print("-------現在總共有---------")
                    for number in favorites {
                        print("\(number.name ?? "no name")")

                    }
                } catch {}
            }
        } else {
            //delete
            sender.tintColor = UIColor(red: 165/255.0, green: 170/255.0, blue: 178/255.0, alpha: 1.0)
            sender.layer.borderColor = UIColor(red: 165/255.0, green: 170/255.0, blue: 178/255.0, alpha: 1.0).cgColor
            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                for item in favorites where item.name == products[sender.tag].name {
                    context.delete(item)

                    appDelegate.saveContext()
                    print("-------現在總共有---------")
                    for number in favorites {
                        print("\(number.name ?? "no name")")

                    }
                }
            }
        }
    }

            // UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //返回每个item的size
        return CGSize.init(width: 154, height: 160)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        productID = products[indexPath.item].id
    }

    func manager(_ manager: ProductManager, didGet products: [Product]) {
        self.products = products

        DispatchQueue.global(qos: .background).async {
            if self.imageArray.count < products.count {
                for i in self.imageArray.count...products.count-1 {
                    let url = URL(string: "http://52.198.40.72/patissier/products/\(products[i].id)/preview.jpg")
                    if let data = try? Data(contentsOf: url!) {
                        DispatchQueue.main.async {
                            self.imageArray.append(UIImage(data: (data))!)

                            self.myCollectionView.reloadData()
                        }
                    }
                }

            }
        }
        DispatchQueue.main.async {
            self.myCollectionView.reloadData()
        }
    }

    func manager(_ manager: ProductManager, didFailWith error: Error) {
        print(error)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        DispatchQueue.main.async {
        scrollView.loadControl?.update()
        }
    }

    func loadMore(sender: AnyObject?) {
        DispatchQueue.main.asyncAfter(deadline: (.now() + 2.0)) {
            self.productManager.requestProducts()
            self.myCollectionView.loadControl?.endLoading()
            self.myCollectionView.reloadData()

        }
}
}
